# gitpod-dotfiles

Dotfiles configuration for development environments with modern CLI tools.

## Features

- **Claude Code CLI**: AI-powered coding assistant in your terminal
- **Gemini CLI**: Google's AI assistant for command line
- **Python uv**: Fast Python package manager
- **Fish Shell**: Modern shell with advanced features and custom functions
- **Deno**: Modern runtime for JavaScript and TypeScript
- **tmux**: Terminal multiplexer with Catppuccin theme and plugin support
- **fzf**: Command-line fuzzy finder for files, directories, and git branches
- **ripgrep**: Ultra-fast text search tool
- **bat**: Syntax-highlighted file viewer
- **tree**: Directory tree visualization
- **fnm**: Fast Node Manager for Node.js versions
- **LLM Tool**: Command-line interface for language models
- **Aider Chat**: AI pair programming tool
- **Private Repository Support**: Easy cloning of private repositories

## Installation

Run the setup script:

```bash
./setup.sh
```

## What's Installed

### Core Tools
- Node.js 20.x (for CLI tools)
- Claude Code (`claude` command)
- Gemini CLI (`gemini` command)
- Python uv package manager
- Deno runtime (`deno` command)
- tmux terminal multiplexer
- Fish shell (set as default)
- fzf fuzzy finder
- ripgrep (rg) text search
- bat syntax highlighter
- tree directory visualizer
- fnm Node version manager

### Python Tools (via uv)
- `llm` - Command-line interface for language models
- `aider-chat` - AI pair programming tool

### Configuration
- Fish shell with advanced functions, key bindings, and custom shortcuts
- tmux with Catppuccin theme, TPM plugin manager, and battery status
- fzf integration with fish shell for fuzzy finding
- Git aliases and advanced git workflow functions
- AWS CLI configuration

## Usage

### Claude Code
```bash
claude
```

### Gemini CLI
```bash
gemini
```

### Private Repository Cloning
```bash
clone-private-repo https://github.com/user/private-repo.git my-repo
```

### Deno
```bash
deno run https://deno.land/std/examples/welcome.ts
deno test
```

### tmux
```bash
tmux                    # Start new session
tmux attach            # Attach to existing session
tmux list-sessions     # List sessions

# Key bindings (prefix is Ctrl-a)
Ctrl-a + r             # Reload config
Ctrl-a + v             # Split vertically
Ctrl-a + h             # Split horizontally
Ctrl-a + |             # Split vertically (alternative)
Ctrl-a + -             # Split horizontally (alternative)
Ctrl-a + q             # Kill session (with confirmation)
Ctrl-a + C             # Create new window with name
Ctrl-a + I             # Install plugins
```

### Advanced Fish Features
```bash
# Interactive directory search
Ctrl+F

# Interactive git branch selection
Ctrl+G

# Search command history
Ctrl+H

# Search and navigate directories
searchdir ~/projects

# Fuzzy search with ripgrep
rg-fzf

# LLM-powered git commit messages
git_llm -m claude-3-sonnet
generate_llm_commit -m claude-3-sonnet

# Search fish configuration
search_fish_config git
```

### Python Tools
```bash
llm "What is the meaning of life?"
aider
```

## Testing

Test the setup in a container:

```bash
./test-dotfiles.sh
```

This will:
1. Build a Docker image with your dotfiles
2. Run tests to verify all tools are installed correctly
3. Clean up afterwards

## Files

- `setup.sh` - Main installation script
- `fish-config.fish` - Fish shell configuration
- `tmux.conf` - tmux terminal multiplexer configuration
- `private-repo-setup.sh` - Private repository cloning script
- `Dockerfile` - For testing the setup
- `docker-compose.yml` - Docker compose configuration
- `test-dotfiles.sh` - Test script

## Environment Variables

Set these environment variables before running setup:

- `GITHUB_USER_EMAIL` - Your GitHub email
- `GITHUB_USER_NAME` - Your GitHub username