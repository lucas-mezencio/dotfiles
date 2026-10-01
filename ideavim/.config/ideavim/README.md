# `ideavimrc` — 1:1 port of LazyVim to IntelliJ

This module maps the Neovim LazyVim configuration to IdeaVIM so muscle memory
transfers cleanly when working in IntelliJ Ultimate.

## Install

```sh
cd /home/lucas/dotfiles
stow ideavim
```

This symlinks `dotfiles/ideavim/.config/ideavim/ideavimrc` →
`~/.config/ideavim/ideavimrc`, which is the XDG-standard path IdeaVIM picks
up automatically (also accepts `~/.ideavimrc`).

After editing `ideavimrc`, reload without restarting the IDE:

```
:source ~/.config/ideavim/ideavimrc
```

## Layout

`ideavimrc` is split into five sections that mirror the migration plan:

1. **Configs** — `scrolloff`, indentation, search, clipboard, etc.
2. **Save & Format** — `<leader>s` reformats (IntelliJ auto-saves).
3. **Navigation** — Harpoon → IntelliJ Bookmarks; find files / grep / project tree.
4. **LSP** — `gd`/`gD`/`grr`/`grn`/`K`/`gK`/`gra`/etc. → IntelliJ actions.
5. **Others** — comments, surround, file ops, etc.

## Leader

`<Space>` — same as Neovim/LazyVim. Set with `let mapleader = " "` near the
top of the file.

## IntelliJ auto-save

Make sure IntelliJ auto-saves (otherwise `<leader>s` does format, but
nothing saves):

`Settings → Appearance & Behavior → System Settings → Save files when...`
→ enable "Save files automatically" if not already on.

## Native IdeaVIM extensions (enabled in this file, no Marketplace install)

| `set` line | Provides | Neovim equivalent |
|---|---|---|
| `set surround` | `ys{motion}{c}`, `ds{c}`, `cs{old}{new}`, `S` | vim-surround |
| `set commentary` | `gcc`, `gc{motion}` | vim-commentary / ts-comments |
| `set mini-ai` | `aq`/`iq`, `ab`/`ib` | mini.ai |
| `set argtextobj` | `aa`/`ia` | argtextobj.vim |
| `set textobj-entire` | `ae`/`ie` | vim-textobj-entire |
| `set ReplaceWithRegister` | `gr{motion}` | ReplaceWithRegister |

These are all built into IdeaVIM. No external install.

## Quick reference

| Action | Key | Action ID |
|---|---|---|
| Reformat code | `<leader>s`, `<leader>cf` | `ReformatCode` |
| Toggle bookmark on line | `<leader>a` | `ToggleBookmark` |
| Show bookmarks | `<leader>h` | `ShowBookmarks` |
| Jump to bookmark N | `<leader>1..9` | `GotoBookmark1..9` |
| Find file | `<leader>pf` | `GotoFile` |
| Find in path | `<leader>pg`, `<leader>psw` | `FindInPath`, `FindWordAtCaret` |
| Recent files | `<leader><leader>` | `RecentFiles` |
| Project view | `<leader>pv` | `ActivateProjectToolWindow` |
| Next diagnostic | `<leader>psd` | `GotoNextError` |
| Line diagnostics | `<leader>psD` | `ShowErrorDescription` |
| Go to definition | `gd`, `gD` | `GotoDeclaration` |
| Go to implementation | `gi` | `GotoImplementation` |
| Go to type definition | `gy` | `GotoTypeDefinition` |
| Find references | `grr` | `FindUsages` |
| Rename | `grn` | `RenameElement` |
| Quick doc | `K` | `QuickJavaDoc` |
| Parameter info | `gK` | `ParameterInfo` |
| Show intentions | `gra` | `ShowIntentionActions` |
| Next reference | `]]` | `GotoNextHighlightedElement` |
| Prev reference | `[[` | `GotoPrevHighlightedElement` |
| Close editor | `<leader>bd` | `CloseContent` |
| New file | `<leader>fn` | `NewElement` |
| Prev/next editor | `<S-h>`, `<S-l>` | `PreviousEditor`, `NextEditor` |
| Clear hlsearch | `<Esc>` | `:nohlsearch` |
| Centered scrolling | automatic | `scrolloff=15` |

## Notable design choices

- **`<C-s>` is unmapped** — IntelliJ handles save itself; `<leader>s` is
  reused for `ReformatCode`.
- **`<C-h/j/k/l>` window navigation is disabled** — IntelliJ uses these for
  tool window navigation. Enable the commented lines at the bottom of
  `ideavimrc` if you prefer vim-style behavior.
- **`unnamedplus` clipboard** — yanks automatically land in the system
  clipboard, so no `<leader>y` is mapped.
- **`j`/`k` → `gj`/`gk`** is a simple remap (LazyVim used an `<expr>`
  mapping to keep `[count]` semantics; IntelliJ handles count with `gj`/`gk`
  fine for typical usage).
- **`gD` and `gd` both map to `GotoDeclaration`** — IntelliJ doesn't
  distinguish the two the way Neovim does.
- **`<leader>1..9` jumps to bookmarks 1..9**, but you set those bookmarks
  with the default IntelliJ shortcut `Ctrl+Shift+1..9` (the leader mapping
  only handles the jump side).

## What was deliberately NOT ported

| Neovim | Reason |
|---|---|
| `flash.nvim` (`fa`/`fF`/`fr`) | Dropped per request — can be added later via `IdeaVim-EasyMotion` + `AceJump` Marketplace plugins + `set easymotion`. |
| `mini.surround` (`sa`/`sd`/`sf`/`sF`/`sh`/`sr`/`sn`) | Replaced with the native `set surround` (vim-surround syntax). Different keyset, more standard. |
| `toggleterm.nvim` | IntelliJ has a built-in terminal. |
| `lazygit` | IntelliJ has Git tool window. |
| `trouble.nvim` | IntelliJ has TODO tool window. |
| `nvim-dap` | IntelliJ has Run/Debug. |
| `tmux-sessionizer` (`<C-f>`, `<M-*>`) | Out of scope — tmux lives in tmux. |
| `grug-far.nvim` (`<leader>psr`) | Replaced by IntelliJ's `FindInPath`. |
| `todo-comments.nvim` (`<leader>psT`) | IntelliJ TODO tool window + `Bookmark` lines. |
| `<leader>xa` (`chmod +x`) | Not applicable. |