# dotfiles

Personal dotfiles for macOS, managed with a bare git repository.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/briancorbinxyz/dotfiles/main/install.sh | bash
```

This will:
- Install Homebrew (if needed)
- Clone dotfiles to `~/.dotfiles` as a bare repo
- Install oh-my-zsh
- Install all packages from Brewfile
- Set up npm global tools
- Configure bat themes

## What's Included

### Shell
- **Zsh** with oh-my-zsh, powerlevel10k theme
- **Atuin** for shell history sync
- **zsh-autosuggestions** and **zsh-syntax-highlighting**

### Terminal
- **Alacritty** / **Ghostty** configs
- **MesloLGS Nerd Font**

### Editor
- **Neovim** with LazyVim

### CLI Tools
- `bat` - better cat
- `lsd` - better ls
- `ripgrep` - better grep
- `fzf` - fuzzy finder
- `zoxide` - smarter cd
- `jq` / `yq` - JSON/YAML processing
- `httpie` - better curl
- `gh` - GitHub CLI
- And more...

## Usage

After install, use the `dotfiles` alias for git operations:

```bash
dotfiles status
dotfiles add ~/.config/newapp/
dotfiles commit -m "Add newapp config"
dotfiles push
```

## Manual Setup

If you prefer not to run the install script:

```bash
# Clone as bare repo
git clone --bare https://github.com/briancorbinxyz/dotfiles.git $HOME/.dotfiles

# Configure
git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no

# Checkout (backup conflicts first)
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

# Install packages
brew bundle --file=$HOME/Brewfile
```

## Adding New Configs

1. Add the file/directory to `.gitignore` whitelist
2. Stage and commit:
   ```bash
   dotfiles add ~/.config/newapp/
   dotfiles commit -m "Add newapp config"
   dotfiles push
   ```
