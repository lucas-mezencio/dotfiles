# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a GNU Stow-based dotfiles repository managing configs for two machines:
- **PC** (Arch Linux, Omarchy/Hyprland desktop)
- **Work laptop** (Ubuntu 24.04, ThinkPad)

## Applying configs with Stow

From the repo root, stow a package to symlink its contents into `$HOME`:

```sh
stow <package>          # link a package
stow -D <package>       # unlink a package
stow -R <package>       # re-link (restow) a package
stow --adopt <package>  # adopt existing files into the repo
```

The `.stowignore` excludes: `old-things`, `.git`, `wallpapers`, `local-bins`, `README.md`.

No setup scripts exist — stow packages are applied manually.

## Repository structure

Each top-level directory is a stow package. Its contents mirror `$HOME` layout:

| Package | Target | Notes |
|---|---|---|
| `atuin/` | `~/.config/atuin/` | Shell history manager |
| `env/` | `~/.envs/`, `~/.config/environment.d/` | Shell env vars, functions, secrets |
| `ghostty-work/` | `~/.config/ghostty/` | Work-only terminal config |
| `hypr/` | `~/.config/hypr/` | Hyprland WM (PC only) — modular split across `hyprland.conf`, `bindings.conf`, `input.conf`, `looknfeel.conf`, `monitors.conf` |
| `sway/` | `~/.config/sway/`, `~/.config/swaylock/`, `~/.config/mako/`, `~/.config/waybar/`, `~/.local/bin/` | Sway WM (work ThinkPad/Ubuntu only) — same modular split + wrapper scripts |
| `lazygit/` | `~/.config/lazygit/` | LazyGit TUI |
| `nvim/` | `~/.config/nvim/` | LazyVim-based Neovim config |
| `sesh/` | `~/.config/sesh/` | Session manager |
| `tmux/` | `~/.config/tmux/` | Tmux + tpm plugins (committed into repo) |
| `yazi/` | `~/.config/yazi/` | File manager |
| `zsh/` | `~/` | `.zshrc` using Zinit |

## Machine-specific configs

- **Hyprland** (`hypr/`) — Arch/PC only; not applied on Ubuntu work machine
- **Sway** (`sway/`) — Ubuntu/work ThinkPad only; replicates the Hyprland workflow using sway equivalents (swaylock, swayidle, waybar, mako, walker). Includes two wrapper scripts in `~/.local/bin/`: `sway-lock` and `sway-launcher`. See `sway/.config/sway/config` for the install dependency list.
- **ghostty-work** — Work machine only terminal variant
- **env/**: ROCm/GPU env vars (`HSA_OVERRIDE_GFX_VERSION`, `ROCM_PATH`) are Arch/PC-specific (RX6600)
- **zsh**: uses `mise` for runtime version management; `kubectl`, `aws`, `vagrant` completions loaded conditionally

## Neovim

LazyVim-based. Plugin config lives in `nvim/.config/nvim/lua/plugins/`. Plugin lockfile: `lazy-lock.json`. On Ubuntu, clangd requires:

```sh
sudo apt install clangd-15 libstdc++-12-dev
```

## Shell environment (`env/` package)

Files in `~/.envs/` are sourced by `.zshrc`:
- `env` — exported environment variables
- `functions` — shell functions (yazi integration, tmux helpers)
- `tmux_sesh` — tmux/sesh session bindings
- `secret` — credentials/secrets (gitignored by pattern)

## Tmux

Plugin manager (tpm) and all plugins are committed into the repo under `tmux/.config/tmux/plugins/`. No need to run `tpm install` on a fresh machine — just stow and use.

---

## [APPENDIX] Sway setup — ThinkPad commissioning notes

> **DELETE THIS SECTION** once the sway environment has been tested and confirmed working on the ThinkPad.

This appendix is for the Claude Code instance running on the ThinkPad during the initial sway setup. The sway package is new and untested — expect rough edges. Below is the context and checklist.

### What was built (and where)

All sway config lives in the `sway/` stow package. Key files:

| File | Role |
|---|---|
| `sway/.config/sway/config` | Main config — read this first for the full picture |
| `sway/.config/sway/outputs.conf` | Monitor layout — **likely needs adjusting** (see below) |
| `sway/.config/sway/input.conf` | Keyboard (br/abnt2) + touchpad |
| `sway/.config/sway/bindings.conf` | All keybindings |
| `sway/.config/sway/autostart.conf` | Startup services |
| `sway/.config/swaylock/config` | Lock screen |
| `sway/.config/mako/config` | Notifications |
| `sway/.config/waybar/config` + `style.css` | Status bar |
| `sway/.local/bin/sway-lock` | Lock wrapper script |
| `sway/.local/bin/sway-launcher` | Walker launcher script |
| `setup-thinkpad.sh` | Dependency checker — run this first |

### First-time setup order

1. **Check deps:** `bash ~/dotfiles/setup-thinkpad.sh`
2. **Install** whatever it reports missing (apt + manual installs)
3. **Apply configs:** `cd ~/dotfiles && stow sway`
4. **Validate sway config:** `sway --validate`
5. **Start sway** from a TTY or display manager

### Known things that will likely need fixing

**Output names** — `outputs.conf` assumes `HDMI-A-1` (external) and `eDP-1` (internal). The actual names depend on the ThinkPad's hardware. Check with:
```sh
swaymsg -t get_outputs   # while sway is running
# or
wlr-randr                # standalone tool
```
Then update `sway/.config/sway/outputs.conf` accordingly and `stow -R sway`.

**Internal screen resolution** — configured as `1024x720` per user's description, but many ThinkPads report `1366x768`. If sway complains or the display looks wrong, run `swaymsg -t get_outputs` and correct the resolution in `outputs.conf`.

**walker binary** — `sway-launcher` script expects `walker` in `$PATH`. If it fails, either place the binary in `~/.local/bin/` (already in PATH via `zsh/.zshrc`) or adjust the script.

**polkit agent path** — `autostart.conf` uses `/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1`. On some Ubuntu installs the path is `/usr/libexec/polkit-gnome-authentication-agent-1`. Fix in `autostart.conf` if GUI privilege prompts don't appear.

**Ghostty terminal override** — the `ghostty-work` stow package provides `~/.config/ghostty/config`. Stow that package too: `stow ghostty-work`.

### Packages to stow on the ThinkPad

```sh
cd ~/dotfiles
stow sway
stow ghostty-work
stow zsh
stow nvim
stow tmux
stow lazygit
stow atuin
stow yazi
stow sesh
stow env   # note: skip ROCm env vars — they're GPU-specific to the Arch PC
```

The `hypr/` package must **not** be stowed on this machine.

### After confirming everything works

Delete this entire `[APPENDIX]` section from `CLAUDE.md` and commit.
