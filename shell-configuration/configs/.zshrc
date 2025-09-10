# =====================================================================
# ~/.zshrc - Enhanced Developer Shell Configuration
# Fast-loading, feature-rich, developer-optimized shell setup
# Repository: https://github.com/tiation/TiationSysAdmin
# =====================================================================

# Performance measurement (uncomment to debug startup time)
# zmodload zsh/zprof

# -----------------------------
# 0. Shell Options & Performance
# -----------------------------

# Enable advanced shell options
setopt AUTO_CD              # cd by typing directory name
setopt CORRECT              # spell correction for commands
setopt NO_BEEP              # no beeping
setopt MULTIOS              # perform implicit tees or cats when multiple redirections are attempted
setopt PROMPT_SUBST         # enable parameter expansion in prompts

# History configuration (moved up for immediate effect)
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
setopt APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS
setopt HIST_VERIFY INC_APPEND_HISTORY SHARE_HISTORY

# -----------------------------
# 1. Essential Utilities (Load First)
# -----------------------------

# Fast PATH manipulation functions
path_prepend() {
    case ":$PATH:" in *":$1:"*) return ;; esac
    export PATH="$1:$PATH"
}

path_append() {
    case ":$PATH:" in *":$1:"*) return ;; esac
    export PATH="$PATH:$1"
}

# Lazy loading wrapper for expensive commands
lazy_load() {
    local command="$1"
    local load_script="$2"
    
    eval "$command() {
        unfunction $command
        source $load_script
        $command \"\$@\"
    }"
}

# Enhanced file checking (faster than test -f)
file_exists() { [[ -f "$1" ]] }
dir_exists() { [[ -d "$1" ]] }

# -----------------------------
# 2. Critical Environment Variables
# -----------------------------

# Core paths and variables
export WORKSPACE="$HOME/workspace"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export EDITOR="code"
export BROWSER="open"
export PAGER="less"
export LESS="-R -S -M -i -J --mouse"

# XDG Base Directory specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Build essential PATH first (most commonly used)
path_prepend "/opt/homebrew/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

# -----------------------------
# 3. Oh My Zsh Configuration
# -----------------------------

export ZSH="$HOME/.oh-my-zsh"

# Essential plugins loaded immediately
plugins=(
    git
    colored-man-pages
    command-not-found
)

# Disable automatic updates for faster startup
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

# Source Oh My Zsh
[[ -s "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Enhanced Spaceship prompt configuration
if file_exists "/opt/homebrew/opt/spaceship/spaceship.zsh"; then
    source "/opt/homebrew/opt/spaceship/spaceship.zsh"
    
    # Spaceship configuration
    export SPACESHIP_PROMPT_ORDER=(
        time user dir host git package node docker aws gcloud kubectl terraform
        line_sep battery jobs exit_code char
    )
    export SPACESHIP_RPROMPT_ORDER=(time)
    export SPACESHIP_TIME_SHOW=true
    export SPACESHIP_TIME_COLOR="yellow"
    export SPACESHIP_BATTERY_SHOW=true
    export SPACESHIP_BATTERY_THRESHOLD=20
    export SPACESHIP_EXIT_CODE_SHOW=true
fi

# -----------------------------
# 4. Essential Aliases & Functions
# -----------------------------

# Navigation shortcuts (most frequently used)
alias ws="cd $WORKSPACE"
alias proj="cd $WORKSPACE/10_projects"
alias assets="cd $WORKSPACE/20_assets"
alias docs="cd $WORKSPACE/30_docs"
alias ops="cd $WORKSPACE/40_ops"
alias data="cd $WORKSPACE/70_data"
alias tmp="cd $WORKSPACE/99_tmp"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Enhanced ls aliases with color and better formatting
if command -v eza >/dev/null; then
    # Use eza if available (modern ls replacement)
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -la --icons --group-directories-first --git"
    alias la="eza -la --icons --group-directories-first"
    alias tree="eza --tree --icons --group-directories-first"
else
    alias ll="ls -la"
    alias la="ls -la" 
    alias l="ls -CF"
fi

# Git shortcuts (enhanced)
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gl="git log --oneline --graph --decorate"
alias gll="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gb="git branch"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gm="git merge"
alias gr="git rebase"
alias gt="git tag"
alias gst="git stash"

# Docker shortcuts (enhanced)
alias dps="docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
alias dpa="docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
alias di="docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}'"
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dcl="docker-compose logs -f"
alias dex="docker exec -it"
alias dlog="docker logs -f"

# Kubernetes shortcuts
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgn="kubectl get nodes"
alias kdp="kubectl describe pod"
alias kl="kubectl logs -f"

# System utilities (enhanced)
alias reload="source ~/.zshrc"
alias e="$EDITOR"
alias v="vim"
alias n="nano"
alias c="clear"
alias h="history"
alias pip="pip3"
alias python="python3"
alias py="python3"

# Network utilities
alias myip="curl -s ifconfig.me && echo"
alias localip="ipconfig getifaddr en0"
alias ports="netstat -tuln"
alias listening="lsof -i -P -n | grep LISTEN"

# File operations with safety
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias mkdir="mkdir -p"

# -----------------------------
# 5. Enhanced Functions
# -----------------------------

# Enhanced git commit function
gcom() {
    if [[ -z "$1" ]]; then
        echo "Usage: gcom 'commit message' [files...]"
        return 1
    fi
    
    local message="$1"
    shift
    
    if [[ $# -gt 0 ]]; then
        git add "$@"
    else
        git add .
    fi
    
    git commit -m "$message"
}

# Smart cd with enhanced functionality
cd() {
    builtin cd "$@" && {
        # Auto-ls after cd
        if [[ $(ls -1 | wc -l) -le 20 ]]; then
            [[ -x "$(command -v eza)" ]] && eza --icons --group-directories-first || ls
        fi
        
        # Show git status if in git repo
        if git rev-parse --git-dir >/dev/null 2>&1; then
            echo "📂 $(basename "$(pwd)") | 🔀 $(git branch --show-current 2>/dev/null)"
            local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
            [[ "$changes" -gt 0 ]] && echo "⚡ $changes uncommitted changes"
        fi
    }
}

# Enhanced find functions with better output
find_files() { 
    [[ -z "$1" ]] && { echo "Usage: find_files <pattern>"; return 1; }
    find . -name "*$1*" -type f 2>/dev/null | head -20
}

find_dirs() { 
    [[ -z "$1" ]] && { echo "Usage: find_dirs <pattern>"; return 1; }
    find . -name "*$1*" -type d 2>/dev/null | head -20
}

# Enhanced grep with colors and line numbers
search() {
    [[ -z "$1" ]] && { echo "Usage: search <pattern> [directory]"; return 1; }
    local dir="${2:-.}"
    grep -r --color=always -n "$1" "$dir" 2>/dev/null | head -20
}

# Process utilities
psg() { ps aux | grep -i "$1" | grep -v grep; }
killall_pattern() { ps aux | grep -i "$1" | grep -v grep | awk '{print $2}' | xargs kill; }

# File size and disk usage
sizeof() { du -sh "$@" 2>/dev/null; }
diskspace() { df -h | grep -E '^/dev/' | sort -k5 -hr; }

# Archive functions
mktar() { tar -czf "${1%%/}.tar.gz" "${1%%/}/"; }
untar() { tar -xzf "$1"; }
mkzip() { zip -r "${1%%/}.zip" "$1"; }

# Network utilities
serve() {
    local port="${1:-8000}"
    echo "🌐 Serving current directory at http://localhost:$port"
    python3 -m http.server "$port"
}

# Weather function
weather() {
    local location="${1:-}"
    curl -s "wttr.in/$location?format=3"
}

# -----------------------------
# 6. Development Environment Functions
# -----------------------------

# Quick project setup
newproject() {
    [[ -z "$1" ]] && { echo "Usage: newproject <name> [type]"; return 1; }
    local name="$1"
    local type="${2:-basic}"
    local project_dir="$WORKSPACE/10_projects/$name"
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    case "$type" in
        "node"|"js")
            npm init -y
            mkdir src tests
            echo "console.log('Hello, World!');" > src/index.js
            ;;
        "python"|"py")
            python3 -m venv venv
            echo "venv/" > .gitignore
            echo "print('Hello, World!')" > main.py
            ;;
        "go")
            go mod init "$name"
            echo 'package main\n\nimport "fmt"\n\nfunc main() {\n    fmt.Println("Hello, World!")\n}' > main.go
            ;;
        *)
            touch README.md
            echo "# $name\n\nProject description here." > README.md
            ;;
    esac
    
    git init
    echo "🚀 Created new $type project: $name"
}

# Enhanced development environment launcher
start-dev() {
    local launcher_script="/Users/tiaastor/Downloads/m4-main/scripts/07_startup_launcher.sh"
    if file_exists "$launcher_script"; then
        "$launcher_script" --launch
    else
        echo "⚠️  Development launcher script not found"
        echo "Starting basic development environment..."
        
        # Start common development services
        code .
        [[ -f "docker-compose.yml" ]] && docker-compose up -d
        [[ -f "package.json" ]] && npm start &
    fi
}

# Environment information
envinfo() {
    echo "🖥️  System Information"
    echo "OS: $(sw_vers -productName) $(sw_vers -productVersion)"
    echo "Architecture: $(uname -m)"
    echo "Shell: $SHELL ($ZSH_VERSION)"
    echo "Terminal: $TERM_PROGRAM"
    echo ""
    echo "📁 Directories"
    echo "Home: $HOME"
    echo "Workspace: $WORKSPACE"
    echo "Current: $(pwd)"
    echo ""
    echo "🔧 Development Tools"
    command -v git >/dev/null && echo "Git: $(git --version | cut -d' ' -f3)"
    command -v node >/dev/null && echo "Node: $(node --version)"
    command -v python3 >/dev/null && echo "Python: $(python3 --version | cut -d' ' -f2)"
    command -v docker >/dev/null && echo "Docker: $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
    command -v kubectl >/dev/null && echo "kubectl: $(kubectl version --client --short 2>/dev/null | cut -d' ' -f3)"
}

# -----------------------------
# 7. Enhanced Welcome Message
# -----------------------------

# Enhanced tips array with more categories
tips=(
    "🚀 Navigation: 'ws' → workspace, 'proj' → projects, 'cd dir' shows auto-ls + git status"
    "⚡ Git Power: 'gcom \"msg\"' → add & commit, 'gll' → pretty log, 'gd' → diff"
    "🐳 Docker Pro: 'dps' → formatted ps, 'dcu' → compose up, 'dex container' → exec -it"
    "☸️  Kubernetes: 'k' → kubectl, 'kctx' → switch context, 'kgp' → get pods"
    "🔍 Search Tools: 'search pattern' → grep recursively, 'ff pattern' → find files"
    "📝 Quick Edit: 'e .' → VSCode, 'v file' → vim, 'code .' → current dir in VSCode"
    "🌐 Network Utils: 'myip' → external IP, 'serve' → local HTTP server, 'weather' → forecast"
    "⚙️  Dev Tools: 'newproject name [type]' → scaffold project, 'envinfo' → system info"
    "💡 Pro Tips: Use 'reload' to refresh shell, Ctrl+R for history search"
    "🔧 File Ops: Enhanced 'ls' with eza if installed, 'sizeof dir' → disk usage"
    "📊 Process Utils: 'psg pattern' → grep processes, 'diskspace' → disk usage by partition"
    "🚀 Productivity: 'start-dev' launches dev environment, custom 'cd' shows context"
)

# Enhanced welcome message with system info
show_welcome() {
    local tip_index=$(($(date +%j) % ${#tips[@]} + 1))
    local current_tip="${tips[$tip_index]}"
    local hour=$(date +%H)
    local greeting
    
    # Time-based greeting
    if [[ $hour -lt 12 ]]; then
        greeting="Good morning"
    elif [[ $hour -lt 18 ]]; then
        greeting="Good afternoon" 
    else
        greeting="Good evening"
    fi
    
    # Terminal width detection for responsive design
    local width=${COLUMNS:-80}
    local separator=$(printf '─%.0s' $(seq 1 $((width - 4))))
    
    echo ""
    echo "┌─$separator─┐"
    printf "│  🌟 %-${width}s 🌟 │\n" "$greeting, Tia! You have a wonderful life!"
    echo "├─$separator─┤"
    printf "│  📅 %-${width}s │\n" "$(date +'%A, %B %d, %Y at %I:%M %p')"
    printf "│  📍 %-${width}s │\n" "Current: $(pwd | sed "s|$HOME|~|")"
    
    # Show current git branch if in repo
    if git rev-parse --git-dir >/dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        local status=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        printf "│  🔀 %-${width}s │\n" "Git: $branch${status:+ ($status changes)}"
    fi
    
    printf "│  %s\n" "$current_tip"
    echo "└─$separator─┘"
    echo ""
    
    # Show quick system stats occasionally
    if [[ $(($(date +%j) % 7)) -eq 0 ]]; then
        echo "💻 $(sw_vers -productName) $(sw_vers -productVersion) | $(uname -m) | Load: $(uptime | awk -F'load averages:' '{print $2}')"
        echo ""
    fi
}

# Show welcome message (only in interactive shells, not in tmux/vscode)
if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
    show_welcome
fi

# -----------------------------
# 8. Enhanced Lazy Loading
# -----------------------------

# Function to load heavy components asynchronously
load_heavy_components() {
    {
        # Extended PATH for less frequently used tools
        path_append "$HOME/scripts"
        path_append "$JAVA_HOME/bin"
        path_append "$ANDROID_HOME/cmdline-tools/latest/bin"
        path_append "$ANDROID_HOME/platform-tools"
        path_append "$ANDROID_HOME/emulator"
        path_append "$HOME/Library/pnpm"
        path_append "$HOME/.bun/bin"
        path_append "$HOME/.foundry/bin"
        path_append "$HOME/.ad-setup/bin"
        path_append "/opt/homebrew/opt/node/bin"
        path_append "$HOME/.cargo/bin"
        
        # Additional Oh My Zsh plugins (loaded async for speed)
        plugins+=(
            zsh-completions
            zsh-autosuggestions
            zsh-syntax-highlighting
            docker
            kubectl
        )
        
        # Additional environment variables
        export NVM_DIR="$HOME/.nvm"
        export PNPM_HOME="$HOME/Library/pnpm"
        export BUN_INSTALL="$HOME/.bun"
        export GOOGLE_API_KEY="AIzaSyAnnmpFMnh72TN_t34GZVOR9jtLyHpk_78"
        
    } &
}

# Load heavy components in background
load_heavy_components

# -----------------------------
# 9. Smart Completions & Tools
# -----------------------------

# Enhanced completions loading
{
    # Zsh completions
    autoload -Uz compinit
    
    # Only rebuild completions once per day for speed
    if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
        compinit
    else
        compinit -C
    fi
    
    # Docker completions
    [[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
    
    # Bun completions
    [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun" 2>/dev/null
    
    # Tool-specific completions
    command -v kompose >/dev/null && source <(kompose completion zsh) 2>/dev/null
    command -v helm >/dev/null && source <(helm completion zsh) 2>/dev/null
    command -v kubectl >/dev/null && source <(kubectl completion zsh) 2>/dev/null
    
    # Enhanced completion settings
    zstyle ':completion:*' menu select
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*:descriptions' format '%B%d%b'
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    
} &

# -----------------------------
# 10. Lazy Loading for Expensive Tools
# -----------------------------

# Enhanced NVM lazy loading with version detection
if file_exists "/opt/homebrew/opt/nvm/nvm.sh"; then
    lazy_load "nvm" "/opt/homebrew/opt/nvm/nvm.sh"
    # Add default node to path if available
    if file_exists "$HOME/.nvm/alias/default"; then
        local default_node_version="$(cat $HOME/.nvm/alias/default)"
        path_append "$HOME/.nvm/versions/node/$default_node_version/bin"
    fi
fi

# Enhanced Conda lazy loading
if file_exists "$HOME/miniconda3/bin/conda"; then
    lazy_load "conda" "$HOME/miniconda3/etc/profile.d/conda.sh"
    path_append "$HOME/miniconda3/bin"
fi

# -----------------------------
# 11. External Tool Integration
# -----------------------------

{
    # Optional tool integrations (loaded in background)
    
    # Blockchain tools
    [[ -n "$ENABLE_BLOCKCHAIN_TOOLS" ]] && 
        file_exists "$HOME/.config/blockchain-cli/shell-config.sh" && 
        source "$HOME/.config/blockchain-cli/shell-config.sh" 2>/dev/null
    
    # VPS management tools
    [[ -n "$ENABLE_VPS_TOOLS" ]] && 
        file_exists "$HOME/github/tiation-repos/dev-environment-toolkit/configs/vps-management-aliases.sh" && 
        source "$HOME/github/tiation-repos/dev-environment-toolkit/configs/vps-management-aliases.sh" 2>/dev/null
    
    # Mac terminal enhancements
    file_exists "$HOME/Github/tiation-repos/mac-terminal-enhancements/aliases/xcdev.zsh" && 
        source "$HOME/Github/tiation-repos/mac-terminal-enhancements/aliases/xcdev.zsh" 2>/dev/null
    file_exists "$HOME/Github/tiation-repos/mac-terminal-enhancements/aliases/core.zsh" && 
        source "$HOME/Github/tiation-repos/mac-terminal-enhancements/aliases/core.zsh" 2>/dev/null
    
    # Warp session management
    file_exists "$HOME/.warp_session_backups/session_aliases.sh" &&
        source "$HOME/.warp_session_backups/session_aliases.sh" 2>/dev/null
    
    # FZF integration (if available)
    if command -v fzf >/dev/null; then
        # FZF key bindings and completion
        [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
        
        # Enhanced FZF configuration
        export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --margin=1 --padding=1"
        export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.*' | head -2000"
        
        # FZF aliases
        alias ff="fzf --preview 'cat {}' --preview-window=right:60%"
        alias fcd="cd \$(find . -type d | fzf)"
    fi
    
    # GitHub CLI completions
    command -v gh >/dev/null && eval "$(gh completion -s zsh)" 2>/dev/null
    
} &

# -----------------------------
# 12. Performance & Cleanup
# -----------------------------

# Clean up PATH duplicates (efficient)
typeset -U PATH

# Remove broken symlinks from PATH
cleanup_path() {
    local newpath=""
    local dir
    for dir in ${(s.:.)PATH}; do
        [[ -d "$dir" ]] && newpath="$newpath:$dir"
    done
    export PATH="${newpath#:}"
}

# Run cleanup in background
{ cleanup_path } &

# -----------------------------
# 13. Terminal Integration
# -----------------------------

# Warp terminal hook
[[ "$TERM_PROGRAM" == "WarpTerminal" ]] && 
    printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh"}}\x9c'

# iTerm2 shell integration
[[ "$TERM_PROGRAM" == "iTerm.app" ]] && 
    file_exists "$HOME/.iterm2_shell_integration.zsh" &&
    source "$HOME/.iterm2_shell_integration.zsh"

# -----------------------------
# 14. Final Optimizations
# -----------------------------

# Speed up git operations in large repos
export GIT_OPTIONAL_LOCKS=0

# Optimize for SSD
export HOMEBREW_NO_AUTO_UPDATE=1

# Performance profiling (uncomment to measure startup time)
# zprof

# =====================================================================
# 🚀 TIATION SHELL - QUICK REFERENCE
# =====================================================================
# Navigation: ws, proj, assets, docs, ops, data, tmp
# Git: gcom "msg", gll (pretty log), gd (diff), gs (status)  
# Docker: dps, dpa, dcu, dcd, dex <container>
# Kubernetes: k, kctx, kns, kgp, kl <pod>
# Search: search <pattern>, ff <name>, fd <dir>
# Utils: envinfo, weather, serve, sizeof, newproject <name> [type]
# Reload: reload (refresh shell)
# Tips: Set ENABLE_BLOCKCHAIN_TOOLS=1 or ENABLE_VPS_TOOLS=1 for extras
# =====================================================================
