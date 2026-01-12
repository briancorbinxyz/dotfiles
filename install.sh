#!/bin/bash
set -e

echo "==> Installing dotfiles for $(whoami)@$(hostname)"

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Clone dotfiles as bare repo
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "==> Cloning dotfiles..."
    git clone --bare https://github.com/briancorbinxyz/dotfiles.git "$HOME/.dotfiles"
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
fi

# Backup conflicting files and checkout
echo "==> Checking out dotfiles..."
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>/dev/null || {
    echo "==> Backing up conflicting files..."
    mkdir -p "$HOME/.dotfiles-backup"
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
        mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
        mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
    done
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
}

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Restore our .zshrc (oh-my-zsh replaces it)
    if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
        mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
    fi
fi

# Install Homebrew packages
echo "==> Installing Homebrew packages..."
brew bundle --file="$HOME/Brewfile"

# Install npm global packages
echo "==> Installing npm global packages..."
npm install -g fkill-cli

# Rebuild bat cache for themes
echo "==> Rebuilding bat cache..."
bat cache --build

# Set up fzf shell integration
echo "==> Setting up fzf..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# Install VS Code extensions
if command -v code &> /dev/null; then
    echo "==> Installing VS Code extensions..."
    grep -v '^#' "$HOME/.config/vscode/extensions.txt" | grep -v '^$' | while read -r ext; do
        code --install-extension "$ext" --force
    done
fi

# Set up asdf version manager and plugins
if [ -f "$HOME/scripts/asdf-setup.sh" ]; then
    "$HOME/scripts/asdf-setup.sh"
fi

# Set remote to GitHub (in case cloned from local)
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" remote set-url origin https://github.com/briancorbinxyz/dotfiles.git

echo ""
echo "==> Done! Start a new shell to load the configuration."
echo "    Use 'dotfiles' alias for git operations (e.g., dotfiles status)"
