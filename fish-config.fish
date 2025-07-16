# Fish shell configuration
# This file will be copied to ~/.config/fish/config.fish

# Set default editor
set -gx EDITOR nano

# PATH configuration
set -gx PATH $HOME/.npm-global/bin $PATH     # npm global packages
set -gx PATH $HOME/.local/bin $PATH          # uv tools
set -gx PATH $HOME/.deno/bin $PATH           # Deno
set -gx PATH $HOME/.bun/bin $PATH            # Bun (from original config)
set -gx PATH $HOME/.local/share/fnm $PATH    # fnm

# History settings
set -g fish_history_ignore_dups yes
set -g HISTSIZE 1000
set -g HISTFILESIZE 2000

# fzf settings
set -gx FZF_ALT_A_OPTS "--preview 'tree -C {} | head -200'"
set fzf_preview_file_cmd batcat -n
# Note: fzf_configure_bindings will be called after fzf.fish is properly installed

# Functions
function searchdir
    set dir (find $argv[1] -path '*/\.*' -prune -o -type d -print 2>/dev/null | fzf +m)
    and cd "$dir"
end

function open_explorer
    if test -n "$argv[1]"
        pushd "$argv[1]"
    end
    explorer.exe .
    if test -n "$argv[1]"
        popd
    end
end

function cdfzf
    set dir (find $argv[1] -type d -maxdepth 1 2>/dev/null | fzf +m)
    and cd "$dir"
end

function rg-fzf
    set RG_PREFIX "rg --column --line-number --no-heading --color=always --smart-case "
    set INITIAL_QUERY ""
    set FZF_DEFAULT_COMMAND "$RG_PREFIX '$INITIAL_QUERY'"
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --ansi --phony --query "$INITIAL_QUERY" \
        --height=50% --layout=reverse \
        --preview 'cat {1} | sed -n {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
end

function fzf_git_branch
    if command -v fzf >/dev/null 2>&1
        git fetch --all --quiet
        set selected_branch (
            git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads refs/remotes |
            awk '{if ($2) {print $1 " (" $2 ")"} else {print $1}}' |
            fzf --height 40% --layout=reverse --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {1}' --preview-window right:50% |
            awk '{print $1}'
        )

        if test -n "$selected_branch"
            if string match -q 'origin/*' $selected_branch
                set local_branch (string replace 'origin/' '' $selected_branch)
                git checkout -b $local_branch $selected_branch
            else
                git checkout $selected_branch
            end
        end
    else
        echo "fzf not found. Please install fzf to use this function."
        git branch -a
    end
end

function git_llm
    # Parse arguments
    set -l options 'm/model=' 'n' 'i/ignore=+'
    argparse $options -- $argv
    or return

    # Check if we're in a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Error: Not in a git repository" >&2
        return 1
    end

    # Get current branch
    if set -q _flag_n
        set -l name "NOJIRA"
    else
        set branch (git branch --show-current 2>/dev/null; or git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if test -z "$branch"
            echo "Error: Unable to determine current git branch" >&2
            return 1
        end
        set name $branch
    end

    # Build exclude pattern for git diff
    set -l exclude_pattern
    if set -q _flag_ignore
        for file in $_flag_ignore
            set exclude_pattern $exclude_pattern ":(exclude)$file"
        end
    end
   
    # Check for changes (staged or unstaged) with excludes
    set -l diff (git diff --staged $exclude_pattern; git diff $exclude_pattern)
    if test -z "$diff"
        echo "Error: No changes detected (staged or unstaged)" >&2
        return 1
    end

    # Set default model if not provided
    set -q _flag_model; or set _flag_model "default_model"

    # Run LLM command
    llm -m $_flag_model "You have Git branch: $branch here,and Changes: $diff here. Now Create a short succint one liner commit message for this diff. Make sure the commit conveys the change in 30 words or less.
    Make sure your commits have following format: {BRANCH} | Prasham | OnelinerCommitMessage.
    Some good examples of the commit are:
    TestApiGateway | Prasham | Added x-ray logs in Api Gateway and cleanup customer register handler
    JIRA-12366 | Prasham | Created new resources and adding lambda shell
    NOJIRA | Prasham | Fixed lint errors in files x.ts, y.ts and z.ts"
end

function generate_llm_commit
    set -l options 'm/model='
    argparse $options -- $argv
    or return
    git commit -a -m (git_llm -m $_flag_model)
end

function remove_from_path
    set -l path_to_remove $argv[1]
    set -l new_path

    for path_entry in (string split : $PATH)
        if test "$path_entry" != "$path_to_remove"
            set new_path $new_path $path_entry
        end
    end
    set --erase PATH
    set -xU PATH $new_path
end

function on_directory_change --on-event fish_prompt
    set -l current_dir (pwd)
    
    # Check if the current directory matches your specific path
    if string match -q "~/Code/NMG" $current_dir
        # Wait for 2 seconds (you can adjust this value)
        sleep 2
        
        # Run your desired command
        echo "Entered specific directory, running command..."
        handleAwsSso.sh NMG
    end
end

function search_fish_config --description 'Search fish bindings and abbreviations'
    # Parse arguments
    set -l options 't/type=' 's/scope='
    argparse $options -- $argv
    
    # Set defaults
    set -l type 'both'
    set -l scope 'user'
    set -l search_term $argv[1]
    
    # Process type flag
    if set -q _flag_type
        switch $_flag_type
            case 'b' 'binds' 'bind' 'binding' 'bindings'
                set type 'binds'
            case 'a' 'abbr' 'abbreviation' 'abbreviations'
                set type 'abbr'
            case '*'
                set type 'both'
        end
    end
    
    # Process scope flag
    if set -q _flag_scope
        switch $_flag_scope
            case 'u' 'user' 'custom' 'mine'
                set scope 'user'
            case '*'
                set scope 'all'
        end
    end
    
    # Create a temporary file for our output
    set -l temp_file (mktemp)
    
    # Function to filter default bindings
    function is_user_binding
        string match -r '^bind (.+)$' "$argv[1]" >/dev/null
    end
    
    # Add content based on type and scope
    if test "$type" = "both" -o "$type" = "binds"
        echo "=== KEYBOARD BINDINGS ===" > $temp_file
        if test "$scope" = "user"
            bind | while read -l line
                if is_user_binding "$line"
                    echo $line >> $temp_file
                end
            end
        else
            bind >> $temp_file
        end
    end
    
    if test "$type" = "both" -o "$type" = "abbr"
        echo -e "\n=== ABBREVIATIONS ===" >> $temp_file
        if test "$scope" = "user"
            # All abbreviations are user-defined in fish
            abbr -l >> $temp_file
        else
            abbr -l >> $temp_file
        end
    end
    
    if test -n "$search_term"
        # If search term provided, use grep
        grep -i "$search_term" $temp_file
    else
        # Otherwise use fzf for interactive search
        cat $temp_file | fzf --header 'Press CTRL-C to exit
Type: '"$type"' | Scope: '"$scope"'
Options: -t/--type (binds|abbr|both) -s/--scope (user|all)' \
                            --layout=reverse \
                            --border \
                            --prompt 'Search config > '
    end
    
    # Clean up
    rm $temp_file
end

# Abbreviations (Fish's version of aliases)
abbr -a reload 'source ~/.config/fish/config.fish'
abbr -a own 'sudo chown -R $USER'
abbr -a openFishConfig 'code ~/.config/fish/config.fish'
abbr -a ll 'ls -lah'
abbr -a la 'ls -la'
abbr -a lsAlias 'cat ~/.config/fish/config.fish | grep abbr'
abbr -a fserve 'deno run --allow-net --allow-read jsr:@std/http/file_server'
abbr -a cx 'sudo chmod +x'
abbr -a mitra 'ComputerUseAgent'

# Common shortcuts
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a python 'python3'
abbr -a pip 'uv pip'

# Git abbreviations (merged and optimized)
abbr -a gs 'git status'
abbr -a gits 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git pull'
abbr -a gd 'git diff'
abbr -a gb 'git branch'
abbr -a gco 'git checkout'
abbr -a gitpull 'git stash; and git pull; and git stash pop'
abbr -a gitpush 'git push; and git push --tags; and git stash clear'
abbr -a gcb 'git checkout -b'
abbr -a glg 'git log --stat'
abbr -a glgp 'git log --stat -p'
abbr -a glgg 'git log --graph'
abbr -a glgga 'git log --graph --decorate --all'
abbr -a glgm 'git log --graph --max-count=10'
abbr -a glo 'git log --oneline --decorate'
abbr -a gchanged 'git status --porcelain'
abbr -a gitdiff 'git difftool'
abbr -a gsw 'git switch'
abbr -a gswb 'git switch -c'

# Tmux shortcuts
abbr -a t 'tmux'
abbr -a ta 'tmux attach'
abbr -a tl 'tmux list-sessions'
abbr -a tn 'tmux new-session'

# Deno shortcuts
abbr -a d 'deno'
abbr -a dr 'deno run'
abbr -a dt 'deno test'

# Claude shortcuts
abbr -a cld 'claude'
abbr -a cldu 'claude update'
abbr -a cldc 'claude --continue'
abbr -a cltr 'claude-trace'
abbr -a cltra 'claude-trace --include-all-requests'
abbr -a cldusr 'code ~/.claude/'

# Cross-platform aliases (Windows/WSL support)
if test -n "$WSL_DISTRO_NAME"
    alias pbpaste "powershell.exe Get-Clipboard"
    alias pbcopy "clip.exe"
    alias explorer "explorer.exe"
end

# Key bindings
bind \cg 'fzf_git_branch'
bind \b 'backward-kill-word'
bind \eC 'code .'
bind \eg 'git status'
bind \eL 'llm logs list'
bind \et 'tmux'
bind \eT\eN 'tmux-nmg.sh'
bind \eT\eL 'tmux-llm.sh'
bind \er 'source ~/.config/fish/config.fish'
bind \eH 'handleAwsSso.sh NMG'
bind \eH\eP 'handleAwsSso.sh NMGPROD'
bind \eT\ed 'denoServers'

# fnm (Fast Node Manager) initialization
if type -q fnm
    fnm env | source
end

# Fish prompt customization
function fish_prompt
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color normal
    echo -n ' $ '
end

# Welcome message
function fish_greeting
    echo "Welcome to Fish Shell!"
    echo "🤖 Claude Code and Gemini CLI are available"
    echo "⚡ Use 'claude' or 'gemini' commands to get started"
    echo "🔍 Use Ctrl+F for directory search, Ctrl+G for git branches"
end