# Rex session persistence

Rex restores sessions after a server restart when the server runs with
`--state-dir`, and it now restores the programs too: programs report the
command that starts them again with OSC 7577, and after a restart each
terminal runs its chosen resume record (see
`rex api describe com.superlogical.terminal.program_resume_records`). pi,
claude, codex and friends report their resume command themselves, so no
custom watcher is needed.

The one remaining piece is macOS-specific: the Rex for Mac app launches its
own server *without* `--state-dir`, and `rex server install` does not support
macOS yet. So a launchd agent starts the server first:

- **launchd agent** (`~/Library/LaunchAgents/com.superlogical.rex.server.plist`,
  absolute paths, not symlinked) runs `rex server start --state-dir
  ~/Library/Application Support/rex/state` at login, before the Rex app can
  spawn its own server without the flag.

## What gets restored

- Sessions, windows, pane layout, labels, working directories — by Rex itself
  (`--state-dir` + `--restore`, saved on graceful stop).
- Programs that report an OSC 7577 resume record — by Rex, which runs the
  record's command in its recorded cwd after a restart.

Not restored: scrollback, in-pane shell history, and programs that don't
report a resume record.

## Restarting the server

Run `rex server stop`. The server is detached, so start it again with
`rex server start --state-dir "$HOME/Library/Application Support/rex/state"`
(or log out and back in). Prefer this over the app's "Restart Server…"
action, which restarts the server *without* `--state-dir`.

## Caveats

- If the Rex app launches before the launchd agent, the server runs without
  `--state-dir`. Fix: quit the app, `rex server stop`, start it again with
  the command above, reopen the app.
- The server only saves sessions on a graceful stop (`rex server stop`,
  SIGTERM). A crash or SIGKILL loses them.
