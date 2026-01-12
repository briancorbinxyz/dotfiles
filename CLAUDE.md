# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles repository for an M1 Mac (aarch64-darwin), using **nix-darwin** and **home-manager** for declarative system/user configuration, alongside **Homebrew** for additional packages and traditional application configs.

The repository uses a **bare git repository pattern** with the working tree set to `$HOME`. Access via the `dotfiles` alias defined in `.zshrc`:
```bash
dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

## Common Commands

### Apply Nix-Darwin Configuration (System-Level)
```bash
darwin-rebuild switch --flake ~/.config/nix-darwin/#corbinm1mac
```

### Apply Home-Manager Configuration (User-Level)
```bash
home-manager switch --flake ~/.config/home-manager/
```

### Install Homebrew Packages
```bash
brew bundle --file=~/dotfiles/Brewfile
```

### Dotfiles Git Operations
```bash
dotfiles status
dotfiles add <file>
dotfiles commit -m "message"
dotfiles push
```

## Architecture

### Configuration Layers

1. **Nix-Darwin** (`.config/nix-darwin/`) - System-level macOS configuration
   - `flake.nix` - Flake entry point, defines host `corbinm1mac`
   - `configuration.nix` - System packages and settings

2. **Home-Manager** (`.config/home-manager/`) - User-level configuration
   - `home.nix` - User packages and dotfile management

3. **Homebrew** (`Brewfile`) - Additional packages and casks not in Nix

4. **Application Configs** (`.config/*/`) - Traditional dotfiles for:
   - `nvim/` - Neovim with LazyVim framework
   - `fish/` - Fish shell (secondary shell)
   - `alacritty/` - Terminal emulator
   - `atuin/` - Shell history manager
   - `bat/` - Syntax-highlighted cat
   - `git/` - Git configuration

5. **Shell** (`.zshrc`) - Primary shell configuration with oh-my-zsh, integrating atuin, fzf, zoxide, pyenv, and other tools

### Neovim Setup

Uses **LazyVim** with custom plugins in `lua/plugins/briancorbinxyz.lua`. Plugin manager is lazy.nvim, configured in `lua/config/lazy.lua`. LSP support for TypeScript and Python via Mason.

### Gitignore Strategy

Uses a **whitelist approach** - ignores everything by default (`*`), then explicitly includes tracked directories and files. When adding new configs, update `.gitignore` to include them.
