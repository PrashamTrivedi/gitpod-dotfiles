#!/bin/bash

# Test script for dotfiles setup
echo "Building and testing dotfiles setup..."

# Build the Docker image
echo "Building Docker image..."
docker-compose build

# Run the container
echo "Starting container..."
docker-compose up -d

# Test the setup
echo "Testing installations..."
docker-compose exec dotfiles-test fish -c "
echo 'Testing installed tools...'
echo

echo 'Node.js version:'
node --version

echo 'NPM version:'
npm --version

echo 'Claude Code installation:'
which claude && echo 'Claude Code: ✓ Installed' || echo 'Claude Code: ✗ Not found'

echo 'Gemini CLI installation:'
which gemini && echo 'Gemini CLI: ✓ Installed' || echo 'Gemini CLI: ✗ Not found'

echo 'Python uv installation:'
which uv && echo 'uv: ✓ Installed' || echo 'uv: ✗ Not found'

echo 'LLM tool installation:'
which llm && echo 'llm: ✓ Installed' || echo 'llm: ✗ Not found'

echo 'Aider-chat installation:'
which aider && echo 'aider: ✓ Installed' || echo 'aider: ✗ Not found'

echo 'Deno installation:'
which deno && echo 'deno: ✓ Installed' || echo 'deno: ✗ Not found'

echo 'Deno version:'
deno --version | head -1 || echo 'deno: ✗ Version check failed'

echo 'tmux installation:'
which tmux && echo 'tmux: ✓ Installed' || echo 'tmux: ✗ Not found'

echo 'tmux version:'
tmux -V || echo 'tmux: ✗ Version check failed'

echo 'Fish shell:'
echo \$SHELL

echo 'Git aliases test:'
alias gs

echo 'Deno aliases test:'
alias d

echo 'tmux aliases test:'
alias t

echo 'Private repo script:'
which clone-private-repo && echo 'clone-private-repo: ✓ Available' || echo 'clone-private-repo: ✗ Not found'

echo 'tmux config:'
test -f ~/.tmux.conf && echo 'tmux.conf: ✓ Configured' || echo 'tmux.conf: ✗ Not found'

echo 'TPM (tmux plugin manager):'
test -d ~/.tmux/plugins/tpm && echo 'TPM: ✓ Installed' || echo 'TPM: ✗ Not found'

echo 'tmux plugins directory:'
test -d ~/.tmux/plugins && echo 'Plugins dir: ✓ Ready' || echo 'Plugins dir: ✗ Not found'

echo 'fzf installation:'
which fzf && echo 'fzf: ✓ Installed' || echo 'fzf: ✗ Not found'

echo 'ripgrep installation:'
which rg && echo 'ripgrep: ✓ Installed' || echo 'ripgrep: ✗ Not found'

echo 'bat installation:'
which bat && echo 'bat: ✓ Installed' || echo 'bat: ✗ Not found'

echo 'tree installation:'
which tree && echo 'tree: ✓ Installed' || echo 'tree: ✗ Not found'

echo 'fnm installation:'
which fnm && echo 'fnm: ✓ Installed' || echo 'fnm: ✗ Not found'

echo 'fzf.fish functions:'
test -f ~/.config/fish/functions/fzf_configure_bindings.fish && echo 'fzf.fish: ✓ Configured' || echo 'fzf.fish: ✗ Not found'

echo 'Fish advanced functions test:'
fish -c 'type fzf_git_branch' && echo 'fzf_git_branch: ✓ Available' || echo 'fzf_git_branch: ✗ Not found'

echo
echo 'Test completed!'
"

# Clean up
echo "Cleaning up..."
docker-compose down
docker image prune -f

echo "Test finished. Check the output above for any issues."