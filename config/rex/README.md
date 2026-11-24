# Rex session persistence

Rex only restores sessions after a server restart when the server runs with
`--state-dir`, and even then it restores only the layout — the programs that
were running don't come back. The Rex for Mac app launches its own server
*without* that flag. This setup fixes both:

- **launchd agent** (`~/Library/LaunchAgents/com.superlogical.rex.server.plist`,
  absolute paths, not symlinked) starts the server at login with
  `--state-dir ~/Library/Application Support/rex/state`, before the Rex app
  can spawn its own, then runs the watcher. `KeepAlive` restarts the watcher
  whenever it exits.
- **`agent-restore.lua`** (this directory) — a `rex do --all` Lua script. It
  snapshots every pane whose foreground program is a known agent (the `AGENTS`
  table at the top of the file, matched on process name, `argv0`, or script
  basename). When the server stops, the script loses its connection and exits;
  launchd starts it again against the new server, and it types each agent's
  resume command into its restored pane. Block IDs survive a restore, so each
  agent lands in exactly the pane it was in.

## What gets restored

- Sessions, windows, pane layout, labels, working directories — by Rex itself
  (`--state-dir` + `--restore`, saved on graceful stop).
- Agent processes (pi, claude, codex, aider, opencode) — by the watcher, via
  each agent's own resume flag. The command runs in the pane's restored cwd,
  so per-directory resume picks the right conversation.

Not restored: scrollback, in-pane shell history, non-agent programs, and any
agent-specific CLI flags (Rex never exposes argv). Two agents that shared a
directory resume the same "most recent" conversation.

## Restarting the server

`rex-restart` (alias in `aliases.zsh`) runs `rex server stop`. launchd brings
the server and watcher back automatically within ~20 seconds. Prefer it over
the app's "Restart Server…" action, which restarts the server *without*
`--state-dir`.

## Caveats

- The first restart after enabling this loses everything: the app-spawned
  server had no `--state-dir`, so there is nothing to restore from yet.
- If the Rex app launches before the launchd agent, the server runs without
  `--state-dir` again. Fix: quit the app, `rex server stop`, wait for launchd
  to bring it back, reopen the app.
- The server only saves sessions on a graceful stop (`rex server stop`,
  SIGTERM). A crash or SIGKILL loses them.

## State and logs

`~/.local/state/rex-agent-restore/`: watcher snapshot (`agents.json`), last
seen server instance (`instance`), launchd logs (`launchd.*.log`; the watcher
logs to stdout, which lands in `launchd.out.log`).
