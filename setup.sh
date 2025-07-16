#!/bin/sh

# Install Gitconfig Provider

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# First cd into root folder
cd ~
curl -L "https://github.com/PrashamTrivedi/gitconfig-provider/releases/latest/download/gitconfig-provider_Linux_x86_64.tar.gz" -o "gitconfig-provider.tar.gz"
mkdir -p ~/gitconfig-provider
tar -xvf gitconfig-provider.tar.gz -C ~/gitconfig-provider
chmod +x ~/gitconfig-provider/gitconfig-provider
sudo ln -s ~/gitconfig-provider/gitconfig-provider /usr/bin/gitconfig-provider

# Install fnm (Fast Node Manager) first
curl -fsSL https://fnm.vercel.app/install | bash

# Source fnm environment properly
export PATH="$HOME/.local/share/fnm:$PATH"
if [ -d "$HOME/.local/share/fnm" ]; then
    eval "$(fnm env)"
fi

# Install Node.js 20.x using fnm (system-agnostic)
fnm install 20
fnm use 20
fnm default 20

# Ensure npm is available after fnm setup
eval "$(fnm env)"
fnm use 20

# Configure npm for user-writable global installs
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH="$HOME/.npm-global/bin:$PATH"

# Add npm global bin to PATH in bashrc
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.deno/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/share/fnm:$PATH"' >> ~/.bashrc


# Install Python uv
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Install system tools (fish, tmux, fzf, ripgrep, bat, tree) automatically
# Detect package manager and install tools
install_system_tools() {
    echo "🔧 Installing system tools..."
    
    # Detect OS and package manager
    if command -v brew >/dev/null 2>&1; then
        echo "🍺 Installing tools with Homebrew..."
        brew install fish tmux fzf ripgrep bat tree || echo "⚠️  Some tools may have failed to install"
    elif command -v apt-get >/dev/null 2>&1; then
        echo "📦 Installing tools with apt-get..."
        sudo apt-get update
        sudo apt-get install -y fish tmux fzf ripgrep bat tree gawk || echo "⚠️  Some tools may have failed to install"
    elif command -v apk >/dev/null 2>&1; then
        echo "🏔️  Installing tools with apk..."
        sudo apk add fish tmux fzf ripgrep bat tree gawk || echo "⚠️  Some tools may have failed to install"
    elif command -v pacman >/dev/null 2>&1; then
        echo "🏛️  Installing tools with pacman..."
        sudo pacman -S --noconfirm fish tmux fzf ripgrep bat tree gawk || echo "⚠️  Some tools may have failed to install"
    elif command -v yum >/dev/null 2>&1; then
        echo "🔴 Installing tools with yum..."
        sudo yum install -y fish tmux fzf ripgrep bat tree gawk || echo "⚠️  Some tools may have failed to install"
    elif command -v dnf >/dev/null 2>&1; then
        echo "🔵 Installing tools with dnf..."
        sudo dnf install -y fish tmux fzf ripgrep bat tree gawk || echo "⚠️  Some tools may have failed to install"
    else
        echo "⚠️  No supported package manager found. Please install manually:"
        echo "   - macOS: brew install fish tmux fzf ripgrep bat tree"
        echo "   - Ubuntu/Debian: sudo apt-get install fish tmux fzf ripgrep bat tree gawk"
        echo "   - Alpine: sudo apk add fish tmux fzf ripgrep bat tree gawk"
        echo "   - Arch: sudo pacman -S fish tmux fzf ripgrep bat tree gawk"
        return 1
    fi
    
    # Verify installations
    echo "✅ Tool installation summary:"
    command -v fish >/dev/null 2>&1 && echo "  ✅ fish" || echo "  ❌ fish"
    command -v tmux >/dev/null 2>&1 && echo "  ✅ tmux" || echo "  ❌ tmux"
    command -v fzf >/dev/null 2>&1 && echo "  ✅ fzf" || echo "  ❌ fzf"
    command -v rg >/dev/null 2>&1 && echo "  ✅ ripgrep" || echo "  ❌ ripgrep"
    command -v bat >/dev/null 2>&1 && echo "  ✅ bat" || echo "  ❌ bat"
    command -v tree >/dev/null 2>&1 && echo "  ✅ tree" || echo "  ❌ tree"
}

# Install system tools
install_system_tools

# Install Fisher package manager for Fish shell (only if fish is available)
if command -v fish >/dev/null 2>&1; then
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" || echo "⚠️  Fisher installation failed"
    echo "✅ Fisher package manager installed"
else
    echo "⚠️  Fish shell not found. Skipping Fisher installation."
fi

# Install Deno
curl -fsSL https://deno.land/install.sh | sh
export PATH="$HOME/.deno/bin:$PATH"

# Set fish as default shell (if fish is installed)
if command -v fish >/dev/null 2>&1; then
    sudo chsh -s $(which fish) $USER
    echo "✅ Fish shell set as default"
else
    echo "⚠️  Fish shell not found. Please install fish and run: sudo chsh -s \$(which fish) \$USER"
    echo "   For now, continuing with bash shell..."
fi

# Install AWS CLI (system-agnostic)
# Detect system architecture and OS
ARCH=$(uname -m)
OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    # macOS
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    rm AWSCLIV2.pkg
elif [ "$OS" = "Linux" ]; then
    if [ "$ARCH" = "x86_64" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    elif [ "$ARCH" = "aarch64" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    else
        echo "Unsupported architecture: $ARCH"
        exit 1
    fi
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
fi

# Verify AWS CLI installation
aws --version

# Create bashrc.d directory and copy configs
mkdir -p ~/.bashrc.d
chmod 755 ~/.bashrc.d
chmod +x "$SCRIPT_DIR/awsConfig"
cp "$SCRIPT_DIR/awsConfig" ~/.bashrc.d/awsConfig

# Copy git-alias to Bashrc
chmod +x "$SCRIPT_DIR/git-alias"
cp "$SCRIPT_DIR/git-alias" ~/.bashrc.d/git-alias


# Apply Gitconfig provider for github (initialize git if needed)
cd ~
git init --quiet || true
~/gitconfig-provider/gitconfig-provider addConfig --provider=Github --key=user.email --value=$GITHUB_USER_EMAIL
~/gitconfig-provider/gitconfig-provider addConfig --provider=Github --key=user.name --value=$GITHUB_USER_NAME
cd "$SCRIPT_DIR"

# Install llm using uv
uv tool install llm

# Install aider-chat using uv
uv tool install aider-chat

# fnm was already installed at the beginning, just ensure PATH is set
export PATH="$HOME/.local/share/fnm:$PATH"

# Setup Fish shell configuration (only if fish is available)
if command -v fish >/dev/null 2>&1; then
    # Setup Fish shell configuration
    mkdir -p ~/.config/fish
    cp "$SCRIPT_DIR/fish-config.fish" ~/.config/fish/config.fish

    # Skip fzf.fish plugin installation due to compatibility issues
    # Users can manually install fzf.fish if they have a compatible fish version
    echo "⚠️  Skipping fzf.fish plugin installation due to compatibility issues"
    echo "   You can manually install it later with: fisher install PatrickF1/fzf.fish"

    # Add PATH exports to Fish config
    echo "" >> ~/.config/fish/config.fish
    echo '# Additional PATH exports added by setup.sh' >> ~/.config/fish/config.fish
    echo 'set -gx PATH $HOME/.npm-global/bin $PATH' >> ~/.config/fish/config.fish
    echo 'set -gx PATH $HOME/.local/bin $PATH' >> ~/.config/fish/config.fish  
    echo 'set -gx PATH $HOME/.deno/bin $PATH' >> ~/.config/fish/config.fish
    echo 'set -gx PATH $HOME/.local/share/fnm $PATH' >> ~/.config/fish/config.fish
    echo "✅ Fish shell configuration completed"
else
    echo "⚠️  Fish shell not found. Skipping fish configuration."
    echo "   You can still use bash with the configured tools"
fi

# Setup tmux configuration (only if tmux is available)
if command -v tmux >/dev/null 2>&1; then
    cp "$SCRIPT_DIR/tmux.conf" ~/.tmux.conf
    
    # Install TPM (tmux plugin manager)
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✅ tmux configuration completed"
else
    echo "⚠️  tmux not found. Skipping tmux configuration."
    echo "   Install tmux to use the configured tmux setup"
fi

# Install tmux plugins (TPM will handle this automatically on first run)
# Users can also press prefix + I to install plugins manually

# Make private repository setup script executable
chmod +x "$SCRIPT_DIR/private-repo-setup.sh"

# Clone claudeSettings to ~/.claude (requires authentication - commented out for container builds)
# git clone https://github.com/PrashamTrivedi/claudeSettings ~/.claude
# Alternative: create empty ~/.claude directory
mkdir -p ~/.claude

# Create symlink for easy access
sudo ln -s "$SCRIPT_DIR/private-repo-setup.sh" /usr/local/bin/clone-private-repo


# Verify Node.js and npm installation
echo "Verifying Node.js installation..."
node --version
npm --version

# Install Claude Code CLI
echo "Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Install Gemini CLI
echo "Installing Gemini CLI..."
npm install -g @google/gemini-cli

echo "Setup completed successfully!"