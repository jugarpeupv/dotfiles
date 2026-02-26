[zsh built in solution](https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-HISTFILE)

![atuin](https://atuin.sh/)

# Requirements for the solution

- Shared history between different shells/tmux sessions
- Persistence between tmux server restarts/crash
- Record a really big number of registries (not only last 1.000 or 10.000 commands)
- Use fzf to fuzzy find over different commands
- Be able to fuzzy find over MULTILINE commands


## Zsh Built-in History vs Atuin
### Zsh Built-in History (`HISTFILE` and related parameters)
- **What it is:** Native zsh functionality controlled by shell parameters like `HISTFILE`, `HISTSIZE`, `SAVEHIST`, and options like `HIST_IGNORE_DUPS`, `SHARE_HISTORY`, etc.
- **Storage:** A single plain-text file on disk (default `~/.zsh_history`)
- **Search:** Basic reverse search via `Ctrl+R`, or `fc`/`history` commands. Limited to substring matching.
- **Scope:** Local to one machine. No built-in way to sync across devices.
- **Context:** Stores only the command and a timestamp (with `EXTENDED_HISTORY`). No working directory, exit code, or duration.
- **Privacy:** The file sits on your filesystem, unencrypted.
- **Dependencies:** Zero -- it's part of zsh itself.
- **Configuration:** A handful of shell variables and options in `.zshrc`.

### Atuin
- **What it is:** A standalone tool (written in Rust) that replaces and extends shell history for bash, zsh, fish, and others.
- **Storage:** An SQLite database, not a flat text file. Enables richer queries.
- **Search:** Full-text and fuzzy search with an interactive TUI. Significantly faster and more flexible than `Ctrl+R`.
- **Scope:** Built-in sync across machines via a sync server (self-hosted or Atuin-hosted).
- **Context:** Stores working directory, exit code, session ID, command duration, and hostname alongside each command.
- **Privacy:** End-to-end encryption for synced data. Your commands are encrypted client-side before leaving the machine.
- **Dependencies:** External binary to install. Hooks into your shell via init scripts.
- **Extras:** Import from existing history files, usage statistics (`atuin stats`), and a growing Desktop app for executable runbooks.

### Summary

| Aspect | Zsh built-in | Atuin |
|---|---|---|
| Setup | Zero -- comes with zsh | Requires install |
| Multi-machine sync | No | Yes (E2E encrypted) |
| Search UX | Basic `Ctrl+R` | Interactive TUI, fuzzy/full-text |
| Stored context | Command + timestamp | Command, cwd, exit code, duration, host |
| Storage format | Flat text file | SQLite database |
| Shell support | zsh only | bash, zsh, fish, etc. |
| Dependencies | None | Rust binary |

