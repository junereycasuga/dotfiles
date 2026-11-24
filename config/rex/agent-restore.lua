-- agent-restore.lua — restore coding agents in their Rex panes after a
-- server restart.
--
-- Rex itself (when started with --state-dir) restores sessions, windows, the
-- pane layout and each pane's working directory, but every pane comes back as
-- a bare shell: the programs that were running are gone. This script fills
-- the gap for coding agents:
--
--   1. While the server runs, it snapshots every pane whose foreground
--      program is a known agent (AGENTS below, matched on the process name,
--      argv0, or script basename).
--   2. When it starts against a server with a new instance id, it finds the
--      restored panes — block IDs survive a restore, so each agent lands back
--      in exactly the pane it was in — and types the agent's resume command.
--
-- The script exits when it loses the server, so a supervisor (launchd, see
-- com.superlogical.rex.server.plist) restarts it, and the fresh run performs
-- the restore. Run it with:
--
--   rex do --all ~/.config/rex/agent-restore.lua
--
-- Test overrides (script args): state_dir=DIR poll=SECONDS

local HOME = os.getenv("HOME")
local WORK_DIR = rex.args.state_dir
  or ((os.getenv("XDG_STATE_HOME") or (HOME .. "/.local/state")) .. "/rex-agent-restore")
local POLL = tonumber(rex.args.poll) or 3

local SNAPSHOT = WORK_DIR .. "/agents.json"
local INSTANCE_FILE = WORK_DIR .. "/instance"

local TERMINAL = "com.superlogical.terminal"

-- Agent programs to restore: program name (matched against the pane's
-- foreground process name, argv0, or script basename) -> resume command typed
-- into the restored pane. The command runs in the pane's restored working
-- directory, so per-directory resume flags pick up the right conversation.
local AGENTS = {
  pi = "pi --continue",
  claude = "claude --continue",
  codex = "codex resume --last",
  aider = "aider --restore-chat-history",
  opencode = "opencode --continue",
}

-- Foreground programs considered "bare shell, safe to type the resume command".
local SHELLS = {
  zsh = true, bash = true, fish = true, sh = true,
  dash = true, nu = true, elvish = true, xonsh = true,
}

local function log(msg)
  print(os.date("%Y-%m-%d %H:%M:%S ") .. msg)
end

local function basename(path)
  return path and path:match("([^/]+)$")
end

local function shell_quote(path)
  return "'" .. path:gsub("'", "'\\''") .. "'"
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
end

local function write_file(path, text)
  local tmp = path .. ".tmp"
  local f = assert(io.open(tmp, "w"))
  f:write(text)
  f:close()
  os.rename(tmp, path)
end

-- The agent key for a foreground process, or nil.
local function agent_for(fg)
  if not fg then return nil end
  local argv0 = fg.argv0 and fg.argv0:gsub("^%-", "")
  for _, key in ipairs({ fg.name, argv0, basename(fg.script) }) do
    if key and AGENTS[key] then return key end
  end
  return nil
end

local function attach(session_id)
  -- Already-attached sessions report an error; it is safe to ignore.
  rex.session.attach{ session_id = session_id }
end

-- Every pane currently running a known agent, as a list of records.
local function collect_agent_panes()
  local panes = {}
  local list, err = rex.call("session.list")
  if not list then return nil, err end

  for _, s in ipairs(list.sessions or {}) do
    attach(s.session_id)
    local view = rex.session.view{ session_id = s.session_id }
    for _, w in ipairs(view and view.windows or {}) do
      for _, layer in ipairs(w.layers or {}) do
        for _, b in ipairs(layer.blocks or {}) do
          if b.creator_name == TERMINAL then
            local proc = rex.block.call(TERMINAL, "process", {
              session_id = s.session_id,
              block_id   = b.block_id,
            })
            local agent = proc and agent_for(proc.foreground)
            if agent then
              table.insert(panes, {
                session_id    = s.session_id,
                session_label = s.label,
                window_label  = w.label,
                block_id      = b.block_id,
                block_label   = b.label,
                agent         = agent,
                resume        = AGENTS[agent],
                cwd           = proc.foreground.cwd,
              })
            end
          end
        end
      end
    end
  end
  return panes
end

local function snapshot(instance_id)
  local panes, err = collect_agent_panes()
  if not panes then return err end
  write_file(SNAPSHOT, rex.json.encode({
    instance_id = instance_id,
    saved_at    = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    panes       = panes,
  }, { indent = true }))
end

-- Type each agent's resume command into its restored pane. Retries briefly
-- because restored shells take a moment to come up.
local function restore(instance_id)
  local text = read_file(SNAPSHOT)
  if not text then return end
  local snap = rex.json.decode(text)
  if not snap or type(snap.panes) ~= "table" then return end
  if snap.instance_id == instance_id then return end -- our own snapshot

  log(string.format("new server instance %s; restoring %d agent pane(s) from %s",
    instance_id, #snap.panes, tostring(snap.instance_id)))

  local pending = snap.panes
  for _ = 1, 20 do
    if #pending == 0 then break end
    local retry = {}
    for _, p in ipairs(pending) do
      attach(p.session_id)
      local proc = rex.block.call(TERMINAL, "process", {
        session_id = p.session_id,
        block_id   = p.block_id,
      })
      if not proc then
        log("restore: " .. p.agent .. " pane " .. p.block_id .. " was not restored, skipping")
      elseif not proc.foreground then
        table.insert(retry, p) -- pane not up yet
      elseif SHELLS[proc.foreground.name] then
        local line = p.resume
        if p.cwd then line = "cd " .. shell_quote(p.cwd) .. " && " .. p.resume end
        local _, werr = rex.block.call(TERMINAL, "write", {
          session_id = p.session_id,
          block_id   = p.block_id,
          data       = line .. "\r",
        })
        if werr then
          log("restore: FAILED to type into pane " .. p.block_id .. ": " .. werr)
        else
          log("restore: relaunched " .. p.agent .. " in pane " .. p.block_id)
        end
      else
        log("restore: pane " .. p.block_id .. " already runs "
          .. tostring(proc.foreground.name) .. ", leaving it alone")
      end
    end
    pending = retry
    if #pending > 0 then rex.sleep(1) end
  end
end

-- Startup ------------------------------------------------------------------

local r, merr = rex.exec{ "mkdir", "-p", WORK_DIR }
if not r or not r.ok then error("cannot create " .. WORK_DIR .. ": " .. tostring(merr or r.stderr), 0) end

local status, err = rex.call("server.status")
if not status then error("cannot reach the server: " .. tostring(err), 0) end
local instance = status.instance_id

if read_file(INSTANCE_FILE) ~= instance then
  rex.sleep(2) -- let the server finish restoring its saved sessions
  restore(instance)
  write_file(INSTANCE_FILE, instance)
end

local serr = snapshot(instance)
if serr then log("snapshot: " .. tostring(serr)) end
log("watching server " .. instance)

local failures = 0
rex.every(POLL, function()
  local st = rex.call("server.status")
  if not st then
    -- The server is gone, and this connection never recovers. Exit so the
    -- supervisor starts a fresh script, which restores the agent panes.
    failures = failures + 1
    if failures >= 2 then
      log("server connection lost; exiting so the supervisor restarts the watcher")
      rex.stop(1)
    end
    return
  end
  failures = 0
  local serr2 = snapshot(st.instance_id)
  if serr2 then log("snapshot: " .. tostring(serr2)) end
end)
