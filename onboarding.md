# Gitpod Dotfiles - Developer Onboarding Guide

Welcome to the Gitpod Dotfiles project! This comprehensive guide will help you understand, contribute to, and use this dotfiles repository effectively.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Quick Start](#quick-start)
3. [Architecture & Design](#architecture--design)
4. [System Journeys](#system-journeys)
5. [Codebase Structure](#codebase-structure)
6. [Key Components](#key-components)
7. [Development Workflow](#development-workflow)
8. [Testing & Validation](#testing--validation)
9. [Conventions & Best Practices](#conventions--best-practices)
10. [Gotchas & Tricky Parts](#gotchas--tricky-parts)
11. [Contributing](#contributing)
12. [Troubleshooting](#troubleshooting)

---

## Project Overview

### Purpose
This is a **system-agnostic dotfiles repository** designed to set up modern development environments with AI-powered CLI tools, shell enhancements, and productivity utilities. It's optimized for cloud development environments (Gitpod, GitHub Codespaces) but works on any Linux/macOS system.

### Key Features
- **AI CLI Tools**: Claude Code, Gemini CLI, LLM tool, Aider Chat
- **Modern Shell**: Fish shell with advanced functions and fzf integration
- **Node.js Management**: fnm (Fast Node Manager) for version management
- **Python Tools**: uv package manager for fast Python tool installation
- **Terminal Multiplexer**: tmux with Catppuccin theme and TPM plugins
- **Search & Navigation**: fzf, ripgrep, bat, tree
- **JavaScript Runtime**: Deno for modern TypeScript/JavaScript
- **Git Workflow**: Advanced git aliases and LLM-powered commit messages
- **Private Repository Support**: Convenient private repo cloning

### Target Users
- Developers working in cloud IDEs (Gitpod, Codespaces)
- AI-assisted development enthusiasts
- Fish shell users seeking advanced productivity features
- Teams needing consistent development environments

---

## Quick Start

### Prerequisites
- Linux (Ubuntu/Debian, Alpine, Arch, RHEL) or macOS
- `curl`, `git`, `sudo` access
- Environment variables:
  - `GITHUB_USER_EMAIL`: Your GitHub email
  - `GITHUB_USER_NAME`: Your GitHub username

### Installation

```bash
# Clone the repository
git clone https://github.com/PrashamTrivedi/gitpod-dotfiles.git
cd gitpod-dotfiles

# Set required environment variables
export GITHUB_USER_EMAIL="your.email@example.com"
export GITHUB_USER_NAME="Your Name"

# Run the setup script
./setup.sh
```

### Post-Installation Steps

1. **Set Fish as default shell** (optional):
   ```bash
   chsh -s $(which fish)
   ```

2. **Configure Claude Code**:
   ```bash
   claude login
   # Or clone your Claude settings
   clone-private-repo https://github.com/yourusername/claudeSettings ~/.claude
   ```

3. **Install tmux plugins**:
   ```bash
   tmux
   # Press Ctrl-a + I to install plugins
   ```

4. **Verify installation**:
   ```bash
   fish
   claude --version
   gemini --version
   deno --version
   ```

---

## Architecture & Design

### Design Principles

1. **System Agnostic**: Automatically detects package managers (apt, apk, brew, yum, dnf, pacman)
2. **Graceful Degradation**: Tools that fail to install don't break the entire setup
3. **User-Space Installation**: Most tools install to `~/.local`, `~/.npm-global`, `~/.deno`
4. **Idempotent**: Can be run multiple times safely
5. **Modular**: Separate configuration files for each tool/shell

### Installation Flow

```
setup.sh (main entrypoint)
├── Install gitconfig-provider (context-aware git config)
├── Install fnm → Node.js 20.x
├── Install Python uv
├── Auto-detect package manager
├── Install system tools (fish, tmux, fzf, ripgrep, bat, tree, gawk)
├── Install Fisher (Fish plugin manager)
├── Install Deno
├── Install AWS CLI (architecture-aware)
├── Install Python tools via uv (llm, aider-chat)
├── Configure Fish shell
│   ├── Copy fish-config.fish → ~/.config/fish/config.fish
│   └── Install fzf.fish plugin
├── Configure tmux
│   ├── Copy tmux.conf → ~/.tmux.conf
│   └── Install TPM (Tmux Plugin Manager)
├── Configure git (gitconfig-provider with GitHub context)
├── Install NPM global tools (Claude Code, Gemini CLI)
└── Setup PATH in ~/.bashrc
```

---

## System Journeys

### Journey 1: New Developer Onboarding

**Goal**: Get a new developer from zero to productive development environment

**Steps**:
1. Developer clones dotfiles repository
2. Sets environment variables (`GITHUB_USER_EMAIL`, `GITHUB_USER_NAME`)
3. Runs `./setup.sh`
4. System detects OS and package manager
5. All tools install automatically
6. Developer switches to Fish shell
7. Developer configures Claude Code credentials
8. Developer installs tmux plugins (Ctrl-a + I)
9. Developer starts using advanced features

**Code Flow**: [setup.sh:1-232](setup.sh)

### Journey 2: AI-Assisted Git Workflow

**Goal**: Use LLM to generate commit messages based on git diff

**Steps**:
1. Developer makes code changes
2. Developer stages changes: `git add .`
3. Developer runs `git_llm -m claude-3-sonnet` or uses `generate_llm_commit`
4. Function extracts current branch name
5. Function gets `git diff` (staged and unstaged)
6. Function calls `llm` with prompt including branch and diff
7. LLM generates commit message in format: `{BRANCH} | {Author} | {Message}`
8. `generate_llm_commit` automatically commits with generated message

**Code Flow**: [fish-config.fish:80-136](fish-config.fish)

### Journey 3: Interactive Directory Navigation

**Goal**: Use fzf-powered directory search and navigation

**Steps**:
1. Developer presses `Ctrl+F` in Fish shell
2. fzf.fish plugin triggers directory search
3. fzf displays fuzzy searchable directory list with preview
4. Developer types to filter
5. Developer selects directory (Enter)
6. Shell changes to selected directory

**Code Flow**: [fish-config.fish:19-28](fish-config.fish), fzf.fish plugin

### Journey 4: Git Branch Management with Preview

**Goal**: Fuzzy search and checkout git branches with commit history preview

**Steps**:
1. Developer presses `Ctrl+G` in Fish shell
2. `fzf_git_branch` function triggers
3. Function runs `git fetch --all`
4. Function lists all local and remote branches
5. fzf displays branches with git log preview
6. Developer selects branch
7. If remote branch: creates local tracking branch
8. If local branch: checks out directly

**Code Flow**: [fish-config.fish:56-78](fish-config.fish)

### Journey 5: Testing Dotfiles in Docker

**Goal**: Validate dotfiles setup in isolated container environment

**Steps**:
1. Developer runs `./test-dotfiles.sh`
2. Script builds Docker image from Dockerfile
3. Container runs setup.sh automatically
4. Script starts container with Fish shell
5. Script runs comprehensive tests:
   - Verifies all tools are installed
   - Tests aliases and abbreviations
   - Checks configuration files
   - Validates Fish functions
6. Script displays test results
7. Script cleans up container

**Code Flow**: [test-dotfiles.sh:1-107](test-dotfiles.sh) → [Dockerfile:1-43](Dockerfile)

---

## Codebase Structure

```
gitpod-dotfiles/
├── setup.sh                    # Main installation script (entrypoint)
├── fish-config.fish            # Fish shell configuration
├── tmux.conf                   # tmux configuration
├── private-repo-setup.sh       # Private repository cloning helper
├── awsConfig                   # AWS environment variables (sourced in bashrc)
├── git-alias                   # Git bash aliases
├── gitconfig-provider-bashrc   # PATH for gitconfig-provider
├── environments.sh             # (Empty/legacy) Environment configurations
├── test-dotfiles.sh            # Docker-based testing script
├── build-and-test.sh          # Alternative build/test with logging
├── Dockerfile                  # Container for testing
├── renovate.json              # Renovate bot configuration
├── .gitignore                 # Ignored files (logs/, scrapbook/)
└── README.md                  # User-facing documentation
```

### File Purposes

| File | Purpose | When Modified |
|------|---------|---------------|
| `setup.sh` | Main installation orchestrator | Adding new tools, changing install logic |
| `fish-config.fish` | Fish shell functions, aliases, key bindings | Adding Fish features, custom functions |
| `tmux.conf` | tmux keybindings, theme, plugins | Customizing tmux behavior |
| `private-repo-setup.sh` | Clone private repos with authentication | Rarely modified |
| `test-dotfiles.sh` | Automated testing in Docker | Adding new test cases |
| `Dockerfile` | Test environment definition | Changing base image or test setup |

---

## Key Components

### 1. setup.sh - Main Orchestrator

**Location**: [setup.sh](setup.sh)

**Key Sections**:

#### Gitconfig Provider Installation (Lines 3-14)
- Downloads platform-specific binary from GitHub releases
- Creates symlink to `/usr/bin/gitconfig-provider`
- Allows context-aware git configuration (different emails for different providers)

#### Node.js Installation (Lines 16-32)
- Uses fnm for fast Node version management
- Installs Node.js 20.x (LTS)
- Ensures npm is available for global tool installation

#### System Package Manager Detection (Lines 42-85)
```bash
install_system_tools() {
    # Auto-detects: brew, apt-get, apk, pacman, yum, dnf
    # Installs: fish, tmux, fzf, ripgrep, bat, tree, gawk
    # Gracefully fails if package manager not found
}
```

**Why this matters**: Makes setup work on macOS, Ubuntu, Alpine, Arch, RHEL/CentOS, Fedora without modification.

#### Path Configuration Strategy (Lines 186-192)
Adds to `~/.bashrc`:
- `~/.npm-global/bin`: npm global packages (Claude Code, Gemini CLI)
- `~/.local/bin`: uv-installed tools (llm, aider-chat)
- `~/.deno/bin`: Deno executables
- `~/.local/share/fnm`: fnm and Node.js

### 2. fish-config.fish - Shell Powerhouse

**Location**: [fish-config.fish](fish-config.fish)

**Key Features**:

#### Path Management (Lines 7-12)
Sets Fish-specific PATH with proper precedence.

#### Advanced Git Functions

**`git_llm` (Lines 80-129)**:
- Parses arguments: `-m/--model`, `-n` (NOJIRA), `-i/--ignore` (exclude files)
- Gets current branch name
- Generates `git diff` excluding specified files
- Calls `llm` tool with structured prompt
- Returns commit message in format: `{BRANCH} | Author | Message`

**Usage**:
```fish
git_llm -m claude-3-sonnet          # Use Claude Sonnet
git_llm -m gpt-4 -n                 # Use GPT-4, NOJIRA branch
git_llm -m claude-3-sonnet -i package-lock.json  # Ignore lockfile
```

**`fzf_git_branch` (Lines 56-78)**:
- Fetches all remote branches
- Formats branches with tracking info
- Shows git log preview in fzf
- Auto-creates local branches for remote branches

#### Fish-Specific Abbreviations (Lines 246-305)
- `abbr`: Fish's intelligent alias system (expands in command line)
- Git shortcuts: `gs`, `ga`, `gc`, `gp`, `gco`, etc.
- Tmux shortcuts: `t`, `ta`, `tl`, `tn`
- Claude shortcuts: `cld`, `cldu`, `cldc`

#### Key Bindings (Lines 313-325)
- `\cg`: Git branch selector (Ctrl+G)
- `\b`: Backward kill word (Ctrl+Backspace)
- `\eg`: Git status (Alt+G)
- `\er`: Reload Fish config (Alt+R)

### 3. tmux.conf - Terminal Multiplexer Setup

**Location**: [tmux.conf](tmux.conf)

**Key Customizations**:

#### Prefix Key (Lines 4-7)
Changed from `Ctrl-b` to `Ctrl-a` (more ergonomic).

#### Window/Pane Numbering (Lines 16-20)
Starts at 1 instead of 0 (matches keyboard layout).

#### Vi Mode (Line 23)
Copy mode uses vi keybindings.

#### Pane Splitting (Lines 48-54)
- `|` or `v`: Vertical split
- `-` or `h`: Horizontal split
- Opens in current pane's directory

#### Plugin System (Lines 83-86)
- TPM (Tmux Plugin Manager)
- Catppuccin theme (modern, aesthetic)
- Battery status plugin

#### Theme Configuration (Lines 88-121)
- Catppuccin "macchiato" flavor
- Status bar shows: session, battery, date/time
- Custom icons for window states

### 4. private-repo-setup.sh - Secure Cloning

**Location**: [private-repo-setup.sh](private-repo-setup.sh)

**Purpose**: Simplifies cloning private repositories with proper authentication.

**Usage**:
```bash
clone-private-repo https://github.com/user/private-repo.git my-repo
```

**Flow**:
1. Validates arguments
2. Checks if directory exists (prompts for overwrite)
3. Clones repository to `$HOME/{directory-name}`
4. Uses git credential helper (configured via gitconfig-provider)

---

## Development Workflow

### Making Changes

1. **Clone and setup**:
   ```bash
   git clone https://github.com/PrashamTrivedi/gitpod-dotfiles.git
   cd gitpod-dotfiles
   ```

2. **Create feature branch**:
   ```bash
   git checkout -b feature/my-enhancement
   ```

3. **Make changes** (see [Conventions](#conventions--best-practices))

4. **Test in Docker**:
   ```bash
   ./test-dotfiles.sh
   ```

5. **Commit with semantic format**:
   ```bash
   git add .
   generate_llm_commit -m claude-3-sonnet
   # Or manually: git commit -m "feat: Add new tool installation"
   ```

6. **Push and create PR**:
   ```bash
   git push -u origin feature/my-enhancement
   ```

### Testing Locally

**Option 1: Docker Testing (Recommended)**
```bash
./test-dotfiles.sh
```
- Safe, isolated environment
- Tests complete installation flow
- Verifies all tools install correctly

**Option 2: Local Testing (Careful!)**
```bash
# Create backup first
cp ~/.config/fish/config.fish ~/.config/fish/config.fish.backup
cp ~/.tmux.conf ~/.tmux.conf.backup

# Test your changes
./setup.sh
```

### Debugging Installation Issues

**Enable verbose output**:
```bash
bash -x setup.sh 2>&1 | tee setup-debug.log
```

**Check specific tool installation**:
```bash
which claude || echo "Claude not found"
which gemini || echo "Gemini not found"
fish --version
```

**Inspect Fish configuration**:
```fish
fish
# Check if functions are loaded
type fzf_git_branch
type git_llm
# Check abbreviations
abbr -l | grep git
```

---

## Testing & Validation

### Automated Testing

**Test Script**: [test-dotfiles.sh](test-dotfiles.sh)

**What it tests**:
1. Node.js and npm installation
2. Claude Code CLI availability
3. Gemini CLI availability
4. Python uv installation
5. LLM tool availability
6. Aider-chat installation
7. Deno installation and version
8. tmux installation and config
9. Fish shell as default
10. Git aliases functionality
11. Private repo script availability
12. TPM (Tmux Plugin Manager) setup
13. fzf, ripgrep, bat, tree installation
14. fnm installation
15. fzf.fish plugin installation
16. Fish advanced functions (fzf_git_branch)

### Manual Testing Checklist

After running `setup.sh`:

- [ ] Fish shell launches without errors
- [ ] `claude --version` shows version
- [ ] `gemini --version` shows version
- [ ] `deno --version` shows version
- [ ] `llm --version` shows version
- [ ] `tmux` starts with Catppuccin theme
- [ ] Press `Ctrl-a + r` reloads tmux config
- [ ] Press `Ctrl+G` in Fish shows git branch selector
- [ ] `gs` expands to `git status`
- [ ] `git_llm -m claude-3-sonnet` generates commit message
- [ ] `clone-private-repo` command is available

### CI/CD Integration

**Renovate Bot**: Configured via [renovate.json](renovate.json)
- Automatically updates dependencies
- Creates PRs for package updates

**Recommended GitHub Actions**:
```yaml
name: Test Dotfiles
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Test in Docker
        run: ./test-dotfiles.sh
```

---

## Conventions & Best Practices

### Shell Script Conventions

**File Headers**:
```bash
#!/bin/sh  # Use POSIX sh for maximum compatibility

# Brief description of script purpose
# Usage: ./script.sh [arguments]
```

**Error Handling**:
```bash
# Use || to handle failures gracefully
command || echo "⚠️  Warning: command failed"

# Check exit codes for critical operations
if [ $? -eq 0 ]; then
    echo "✅ Success"
else
    echo "❌ Failed"
    exit 1
fi
```

**User Feedback**:
- Use emoji for visual feedback: ✅ ⚠️ ❌ 🔧 📦
- Always verify installations with clear output
- Provide next steps after setup

### Fish Configuration Conventions

**Function Naming**:
- Use snake_case: `fzf_git_branch`, `search_fish_config`
- Prefix with tool name for clarity: `git_llm`, `on_directory_change`

**Abbreviation Naming**:
- Short, memorable mnemonics: `gs`, `ga`, `gc`
- Consistent prefixes: `g*` for git, `t*` for tmux, `cld*` for claude

**Key Binding Guidelines**:
- `\c` prefix: Core navigation (Ctrl+G for git branches)
- `\e` prefix: Tool/command shortcuts (Alt+G for git status)
- Document all custom bindings in comments

### Git Commit Format

**Preferred format** (when using `git_llm`):
```
{BRANCH_NAME} | {AUTHOR} | {CONCISE_MESSAGE}
```

**Examples**:
```
JIRA-12366 | Prasham | Created new resources and adding lambda shell
NOJIRA | Prasham | Fixed lint errors in files x.ts, y.ts and z.ts
TestApiGateway | Prasham | Added x-ray logs in Api Gateway
```

**Alternative** (semantic commits):
```
feat: Add new tool installation
fix: Resolve fish shell compatibility
docs: Update README with new features
refactor: Make setup.sh system-agnostic
```

### Code Style

**Shell Scripts**:
- Use 4-space indentation
- Quote all variables: `"$variable"`
- Use `[ ]` for POSIX compatibility (not `[[ ]]`)
- Prefer `command -v` over `which`

**Fish Scripts**:
- Use Fish-native constructs (`set`, `test`, `string`)
- Avoid bashisms
- Use `type -q` to check for commands

---

## Gotchas & Tricky Parts

### 1. Fish vs Bash PATH Handling

**Problem**: Fish uses space-separated paths, Bash uses colon-separated.

**Solution**: Use Fish's `set -gx PATH` syntax:
```fish
set -gx PATH $HOME/.local/bin $PATH
```

**In setup.sh** (Bash):
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 2. fnm Initialization Timing

**Problem**: fnm must be sourced before Node.js is available.

**Solution** in setup.sh:
```bash
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env)"
fnm use 20
```

**In Fish config**:
```fish
if type -q fnm
    fnm env | source
end
```

### 3. tmux Plugin Installation

**Problem**: TPM plugins don't install automatically on first run.

**Solution**: User must press `Ctrl-a + I` after first tmux launch, OR run:
```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

### 4. bat vs batcat Binary Name

**Problem**: On Debian/Ubuntu, `bat` is installed as `batcat` (naming conflict).

**Workaround in Fish**:
```fish
set fzf_preview_file_cmd batcat -n
```

**Better solution**:
```bash
# Add to setup.sh for Debian/Ubuntu
if command -v batcat >/dev/null 2>&1; then
    sudo ln -sf $(which batcat) /usr/local/bin/bat
fi
```

### 5. gitconfig-provider Context Switching

**Problem**: Different git identities for different repositories (work vs personal).

**How it works**:
```bash
# Setup (in setup.sh)
~/gitconfig-provider/gitconfig-provider addConfig --provider=Github \
    --key=user.email --value=$GITHUB_USER_EMAIL

# Automatic switching based on remote URL
# If repo remote is github.com → uses Github config
# If repo remote is gitlab.com → uses Gitlab config (if configured)
```

### 6. Fish Abbreviations vs Aliases

**Key Difference**:
- **Abbreviations** (`abbr`): Expand in the command line (visible before Enter)
- **Aliases** (`alias`): Expand after execution (not visible)

**Fish philosophy**: Prefer abbreviations for transparency.

**Example**:
```fish
abbr -a gs 'git status'  # You see "git status" after typing "gs"
alias gs 'git status'     # Command remains "gs" in prompt
```

### 7. Docker Testing Nuances

**Problem**: Dockerfile installs everything as `testuser`, not root.

**Why**: Tests real-world non-root setup, matches cloud IDE behavior.

**Consequence**: `sudo` commands in Dockerfile must grant `NOPASSWD` for testuser.

### 8. WSL-Specific Features

**Problem**: Windows clipboard integration doesn't work in WSL by default.

**Solution** (in fish-config.fish):
```fish
if test -n "$WSL_DISTRO_NAME"
    alias pbpaste "powershell.exe Get-Clipboard"
    alias pbcopy "clip.exe"
end
```

### 9. AWS CLI Configuration

**Problem**: AWS credentials shouldn't be hardcoded.

**Pattern** (in awsConfig):
```bash
export AWS_ACCESS_KEY_ID=$AWS_PERSONAL_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_PERSONAL_SECRET_ACCESS_KEY
```

**User must set** in their environment:
```bash
export AWS_PERSONAL_ACCESS_KEY_ID="your-key"
export AWS_PERSONAL_SECRET_ACCESS_KEY="your-secret"
```

### 10. Claude Code Settings

**Problem**: Claude Code settings aren't committed to dotfiles.

**Reason**: Contains API keys and personal preferences.

**Solution**: Clone separately with `clone-private-repo`:
```bash
clone-private-repo https://github.com/yourusername/claudeSettings ~/.claude
```

---

## Contributing

### Types of Contributions Welcome

1. **New Tool Integrations**
   - Add installation to `setup.sh`
   - Add Fish abbreviations/functions if needed
   - Update README.md
   - Add test validation in `test-dotfiles.sh`

2. **Bug Fixes**
   - Package manager compatibility issues
   - Path configuration problems
   - Fish/Bash compatibility

3. **Documentation**
   - Clarify installation steps
   - Add troubleshooting tips
   - Improve code comments

4. **Testing**
   - Add test cases for new features
   - Improve Docker test coverage

### Pull Request Guidelines

**Before submitting**:
1. Run `./test-dotfiles.sh` successfully
2. Test on at least one Linux distribution
3. Update relevant documentation
4. Follow commit message conventions

**PR Title Format**:
```
<type>: <description>

Types: feat, fix, docs, refactor, test, chore
```

**PR Description Template**:
```markdown
## Changes
- [ ] Added X feature
- [ ] Fixed Y bug

## Testing
- [ ] Tested in Docker
- [ ] Tested on Ubuntu 22.04
- [ ] Tested fish functions

## Documentation
- [ ] Updated README
- [ ] Updated onboarding.md

## Related Issues
Closes #123
```

---

## Troubleshooting

### Setup Fails: "No supported package manager found"

**Cause**: Running on unsupported OS or package manager not installed.

**Solution**:
1. Install one manually: `apt-get`, `brew`, `apk`, etc.
2. Or install tools manually (see README)

### Fish functions not available after setup

**Cause**: Fish config not reloaded.

**Solution**:
```fish
source ~/.config/fish/config.fish
# Or
exec fish
```

### Claude Code: "command not found"

**Possible causes**:
1. npm global bin not in PATH
2. Installation failed silently

**Debug**:
```bash
echo $PATH | grep npm-global  # Should show ~/.npm-global/bin
ls ~/.npm-global/bin/         # Should contain 'claude'
npm list -g @anthropic-ai/claude-code  # Check installation
```

**Fix**:
```bash
npm install -g @anthropic-ai/claude-code
export PATH="$HOME/.npm-global/bin:$PATH"
```

### tmux shows default theme, not Catppuccin

**Cause**: Plugins not installed.

**Solution**:
```bash
# Inside tmux
Ctrl-a + I  # Capital I to install plugins

# Or outside tmux
~/.tmux/plugins/tpm/bin/install_plugins
```

### git_llm: "llm: command not found"

**Cause**: uv tools not in PATH.

**Solution**:
```bash
export PATH="$HOME/.local/bin:$PATH"
uv tool list  # Verify llm is installed
```

### fzf_git_branch shows no preview

**Cause**: Git log command failure or fzf preview not configured.

**Debug**:
```fish
git log --oneline --graph  # Test git log works
echo $FZF_ALT_A_OPTS        # Check fzf config
```

### Private repository cloning fails

**Causes**:
1. Git credentials not configured
2. No SSH key or HTTPS token

**Solutions**:
```bash
# Option 1: SSH key
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub  # Add to GitHub

# Option 2: Credential helper
git config --global credential.helper store
git clone <private-repo>  # Will prompt for credentials once

# Option 3: GitHub CLI
gh auth login
```

---

## Advanced Usage Patterns

### Custom Fish Functions

Add your own functions to `~/.config/fish/config.fish`:

```fish
function project_init --description "Initialize new project"
    mkdir -p $argv[1]
    cd $argv[1]
    git init
    echo "# $argv[1]" > README.md
    echo "Project initialized!"
end
```

### Custom tmux Layouts

Add to `~/.tmux.conf`:

```bash
# Create development layout
bind-key D source-file ~/.tmux/dev-layout

# Where dev-layout contains:
# split-window -h -p 30
# split-window -v
# select-pane -t 0
```

### Extending Git Workflow

Create additional LLM-powered git helpers:

```fish
function git_review --description "AI-powered code review"
    set diff (git diff)
    llm -m claude-3-opus "Review this code change and suggest improvements: $diff"
end
```

### CI/CD Integration

Use dotfiles in GitHub Actions:

```yaml
- name: Setup development environment
  run: |
    git clone https://github.com/PrashamTrivedi/gitpod-dotfiles.git ~/dotfiles
    cd ~/dotfiles
    export GITHUB_USER_EMAIL="ci@example.com"
    export GITHUB_USER_NAME="CI Bot"
    ./setup.sh
    fish
```

---

## Resources

### Internal Documentation
- [README.md](README.md) - User-facing quick reference
- [test-dotfiles.sh](test-dotfiles.sh) - Test suite and validation
- [Dockerfile](Dockerfile) - Container test environment

### External Resources
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [tmux GitHub Wiki](https://github.com/tmux/tmux/wiki)
- [fzf GitHub](https://github.com/junegunn/fzf)
- [Claude Code Documentation](https://docs.claude.com/claude-code)
- [Catppuccin Theme](https://github.com/catppuccin/tmux)

### Related Tools
- [gitconfig-provider](https://github.com/PrashamTrivedi/gitconfig-provider) - Context-aware git config
- [fnm](https://github.com/Schniz/fnm) - Fast Node Manager
- [uv](https://github.com/astral-sh/uv) - Python package manager
- [Deno](https://deno.land) - Modern TypeScript/JavaScript runtime

---

## Maintainers

**Primary Maintainer**: Prasham Trivedi

**Getting Help**:
- GitHub Issues: Report bugs and request features
- GitHub Discussions: Ask questions and share tips

---

## License

This project follows the repository's license terms. Refer to LICENSE file if present.

---

## Changelog

Recent changes (from git history):

- **b63009e**: Fixed setup and added debugging
- **62ae02b**: Add automatic tool installation and resolve fish shell compatibility
- **4eefab3**: Make setup.sh system-agnostic and add comprehensive dotfiles
- **8d06591**: Added useful tools in setup
- **2f7eb61**: Fixing path errors

For detailed history: `git log --oneline`

---

**Welcome aboard! Happy coding with your new supercharged development environment! 🚀**
