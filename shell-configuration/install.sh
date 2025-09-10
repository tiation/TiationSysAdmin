#!/usr/bin/env bash
set -euo pipefail

# Enhanced Shell Configuration Installer
# Part of TiationSysAdmin System Administration Toolkit

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/tiation-shell"
BACKUP_DIR="$HOME/.config/tiation-shell/backups"

print_color() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

print_header() {
    echo
    print_color $CYAN "╔════════════════════════════════════════════════════════════════╗"
    print_color $CYAN "║  🚀 TIATION ENHANCED SHELL CONFIGURATION INSTALLER            ║"
    print_color $CYAN "╚════════════════════════════════════════════════════════════════╝"
    echo
    print_color $BLUE "$1"
    echo
}

print_step() {
    print_color $YELLOW "➤ $1"
}

print_success() {
    print_color $GREEN "✅ $1"
}

print_error() {
    print_color $RED "❌ $1"
}

print_info() {
    print_color $BLUE "ℹ️  $1"
}

# Detect shell type
detect_shell() {
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        echo "zsh"
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

# Backup existing configuration
backup_existing() {
    local shell_type="$1"
    local config_file=""
    
    case "$shell_type" in
        "zsh") config_file="$HOME/.zshrc" ;;
        "bash") config_file="$HOME/.bashrc" ;;
        *) print_error "Unsupported shell: $shell_type"; return 1 ;;
    esac
    
    if [[ -f "$config_file" ]]; then
        print_step "Backing up existing $shell_type configuration"
        mkdir -p "$BACKUP_DIR"
        local backup_name="$(basename "$config_file").backup.$(date +%Y%m%d_%H%M%S)"
        cp "$config_file" "$BACKUP_DIR/$backup_name"
        print_success "Backed up to: $BACKUP_DIR/$backup_name"
    else
        print_info "No existing $shell_type configuration found"
    fi
}

# Install shell configuration
install_config() {
    local shell_type="$1"
    local config_file=""
    local source_config=""
    
    case "$shell_type" in
        "zsh") 
            config_file="$HOME/.zshrc"
            source_config="$REPO_DIR/configs/.zshrc"
            ;;
        "bash") 
            config_file="$HOME/.bashrc"
            source_config="$REPO_DIR/configs/.bashrc"
            ;;
        *) print_error "Unsupported shell: $shell_type"; return 1 ;;
    esac
    
    if [[ ! -f "$source_config" ]]; then
        print_error "Source configuration not found: $source_config"
        return 1
    fi
    
    print_step "Installing enhanced $shell_type configuration"
    cp "$source_config" "$config_file"
    print_success "Configuration installed: $config_file"
}

# Install additional functions
install_functions() {
    print_step "Installing development functions"
    mkdir -p "$CONFIG_DIR/functions"
    
    # Copy function files
    cp "$REPO_DIR/functions/"* "$CONFIG_DIR/functions/" 2>/dev/null || {
        print_info "No additional function files to copy"
    }
    
    # Create functions autoloader
    cat > "$CONFIG_DIR/functions/autoload.zsh" << 'EOF'
# Auto-load development functions
FUNCTIONS_DIR="$HOME/.config/tiation-shell/functions"

if [[ -d "$FUNCTIONS_DIR" ]]; then
    for func_file in "$FUNCTIONS_DIR"/*.zsh; do
        [[ -f "$func_file" && "$func_file" != *"autoload.zsh" ]] && source "$func_file"
    done
fi
EOF
    
    print_success "Development functions installed"
}

# Install themes (if any)
install_themes() {
    local theme_dir="$REPO_DIR/themes"
    if [[ -d "$theme_dir" && $(ls -A "$theme_dir" 2>/dev/null) ]]; then
        print_step "Installing shell themes"
        mkdir -p "$CONFIG_DIR/themes"
        cp -r "$theme_dir/"* "$CONFIG_DIR/themes/"
        print_success "Themes installed"
    else
        print_info "No themes to install"
    fi
}

# Install completions
install_completions() {
    local completions_dir="$REPO_DIR/completions"
    if [[ -d "$completions_dir" && $(ls -A "$completions_dir" 2>/dev/null) ]]; then
        print_step "Installing shell completions"
        mkdir -p "$CONFIG_DIR/completions"
        cp -r "$completions_dir/"* "$CONFIG_DIR/completions/"
        print_success "Completions installed"
    else
        print_info "No completions to install"
    fi
}

# Check dependencies
check_dependencies() {
    print_step "Checking dependencies"
    
    local missing_deps=()
    
    # Essential tools
    command -v git >/dev/null || missing_deps+=("git")
    command -v curl >/dev/null || missing_deps+=("curl")
    
    # Recommended tools
    local recommended_tools=("eza" "fzf" "bat" "ripgrep" "fd")
    local missing_recommended=()
    
    for tool in "${recommended_tools[@]}"; do
        command -v "$tool" >/dev/null || missing_recommended+=("$tool")
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing essential dependencies: ${missing_deps[*]}"
        echo
        print_info "Install with: brew install ${missing_deps[*]}"
        return 1
    fi
    
    print_success "Essential dependencies satisfied"
    
    if [[ ${#missing_recommended[@]} -gt 0 ]]; then
        print_info "Optional tools for enhanced experience: ${missing_recommended[*]}"
        print_info "Install with: brew install ${missing_recommended[*]}"
    fi
}

# Setup Oh My Zsh (for zsh)
setup_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_step "Installing Oh My Zsh"
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        print_success "Oh My Zsh installed"
    else
        print_info "Oh My Zsh already installed"
    fi
    
    # Install useful plugins
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins"
    
    # zsh-autosuggestions
    if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
        print_step "Installing zsh-autosuggestions plugin"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed"
    fi
    
    # zsh-syntax-highlighting
    if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
        print_step "Installing zsh-syntax-highlighting plugin"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugin_dir/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting installed"
    fi
}

# Install Spaceship prompt (for zsh)
install_spaceship_prompt() {
    if ! command -v spaceship >/dev/null && [[ ! -f "/opt/homebrew/opt/spaceship/spaceship.zsh" ]]; then
        print_step "Installing Spaceship prompt"
        if command -v brew >/dev/null; then
            brew install spaceship
            print_success "Spaceship prompt installed"
        else
            print_info "Homebrew not found. Please install Spaceship manually:"
            print_info "brew install spaceship"
        fi
    else
        print_info "Spaceship prompt already available"
    fi
}

# Configure shell as default (optional)
configure_default_shell() {
    local shell_type="$1"
    local shell_path=""
    
    case "$shell_type" in
        "zsh") shell_path="/bin/zsh" ;;
        "bash") shell_path="/bin/bash" ;;
        *) return ;;
    esac
    
    if [[ "$SHELL" != "$shell_path" ]]; then
        print_step "Current shell: $SHELL"
        read -r "change_shell?Set $shell_type as default shell? [y/N]: "
        
        if [[ "$change_shell" =~ ^[Yy]$ ]]; then
            if chsh -s "$shell_path"; then
                print_success "$shell_type set as default shell"
                print_info "Restart your terminal to apply changes"
            else
                print_error "Failed to change default shell"
            fi
        fi
    else
        print_info "$shell_type is already the default shell"
    fi
}

# Create useful aliases
create_shell_aliases() {
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_DIR/tiation-aliases.zsh" << 'EOF'
# Tiation Shell Aliases - Enhanced productivity commands

# Enhanced navigation with better feedback
alias ..='cd .. && pwd'
alias ...='cd ../.. && pwd'
alias ....='cd ../../.. && pwd'

# Better ls commands (with eza if available)
if command -v eza >/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git --header'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
else
    alias ll='ls -la'
    alias la='ls -la'
    alias lt='ls -la'
fi

# Git aliases with enhanced output
alias gst='gstat'     # Use our enhanced git status
alias gad='gadd'      # Use our interactive git add
alias gcm='gcommit'   # Use our semantic commits
alias glg='glog'      # Use our interactive git log

# Development shortcuts
alias serve='dev-serve'
alias proj='proj-init'
alias backup-file='backup'
alias monitor='sysmon'
alias network='nettest'

# System utilities
alias ports='netstat -tuln | grep LISTEN'
alias myip='curl -s ifconfig.me && echo'
alias weather='curl -s wttr.in'
alias reload-shell='exec $SHELL -l'

# Docker shortcuts with better formatting
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dpa='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias di='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'

# Kubernetes shortcuts
alias k='kubectl'
alias kgp='kubectl get pods -o wide'
alias kgs='kubectl get services -o wide'
alias kgn='kubectl get nodes -o wide'
alias kdesc='kubectl describe'
alias klogs='kubectl logs -f'

# Quick file operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'

# Archive shortcuts
alias mktar='tar -czf'
alias untar='tar -xzf'
alias mkzip='zip -r'

# Python shortcuts
alias py='python3'
alias pip='pip3'
alias venv-create='python3 -m venv venv'
alias venv-activate='source venv/bin/activate'

# Node.js shortcuts
alias npm-fresh='rm -rf node_modules package-lock.json && npm install'
alias npm-global='npm list -g --depth=0'

# System monitoring
alias cpu='top -o cpu'
alias mem='top -o mem'
alias disk='df -h'
alias temp='sudo powermetrics -n 1 -s smc | grep -i temp'

# Network utilities
alias ping='ping -c 5'
alias wget='wget -c'
alias speed='speedtest-cli --simple'

print_info() { echo -e "\033[0;34m$*\033[0m"; }
print_success() { echo -e "\033[0;32m$*\033[0m"; }
print_error() { echo -e "\033[0;31m$*\033[0m"; }
print_warning() { echo -e "\033[1;33m$*\033[0m"; }

# Function to show all available aliases
aliases-help() {
    echo "🚀 Tiation Shell - Available Aliases & Functions"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📁 Navigation: .., ..., ...., ws, proj, assets, docs, ops, data, tmp"
    echo "📄 Files: ll, la, lt (tree), cp, mv, rm, mkdir, backup, extract"
    echo "🔀 Git: gst (status), gad (add), gcm (commit), glg (log), g (git)"
    echo "🐳 Docker: dps, dpa, di, dc (compose), dex (exec)"
    echo "☸️  Kubernetes: k, kgp, kgs, kgn, kdesc, klogs"
    echo "🌐 Network: myip, ports, ping, speed, weather, nettest"
    echo "🔧 Development: serve, proj-init, dev-serve, envinfo"
    echo "📊 System: monitor (sysmon), cpu, mem, disk, temp"
    echo "🐍 Python: py, pip, venv-create, venv-activate"
    echo "📦 Node: npm-fresh, npm-global"
    echo "📝 Notes: note, note-search"
    echo ""
    echo "Type any alias name for more info, or 'reload-shell' to refresh configuration"
}

# Load the aliases help on first load
if [[ -z "$TIATION_ALIASES_LOADED" ]]; then
    export TIATION_ALIASES_LOADED=1
    print_success "🎉 Tiation shell aliases loaded! Type 'aliases-help' to see all commands."
fi
EOF
    
    print_success "Shell aliases created"
}

# Update existing configuration to include Tiation enhancements
update_shell_config() {
    local shell_type="$1"
    local config_file=""
    
    case "$shell_type" in
        "zsh") config_file="$HOME/.zshrc" ;;
        "bash") config_file="$HOME/.bashrc" ;;
        *) return 1 ;;
    esac
    
    # Check if already configured
    if grep -q "tiation-shell" "$config_file" 2>/dev/null; then
        print_info "Tiation shell enhancements already configured"
        return 0
    fi
    
    print_step "Adding Tiation shell enhancements to $config_file"
    
    cat >> "$config_file" << EOF

# ═══════════════════════════════════════════════════════════════════
# Tiation Shell Enhancements
# Added by TiationSysAdmin Shell Configuration Installer
# ═══════════════════════════════════════════════════════════════════

# Load Tiation functions
[[ -f "\$HOME/.config/tiation-shell/functions/autoload.zsh" ]] && 
    source "\$HOME/.config/tiation-shell/functions/autoload.zsh"

# Load Tiation aliases
[[ -f "\$HOME/.config/tiation-shell/tiation-aliases.zsh" ]] && 
    source "\$HOME/.config/tiation-shell/tiation-aliases.zsh"

# Warp session management (if available)
[[ -f "\$HOME/.warp_session_backups/session_aliases.sh" ]] && 
    source "\$HOME/.warp_session_backups/session_aliases.sh"

# ═══════════════════════════════════════════════════════════════════
EOF
    
    print_success "Tiation enhancements added to shell configuration"
}

# Test installation
test_installation() {
    print_step "Testing installation"
    
    # Test if functions are available in a new shell
    local test_script=$(cat << 'EOF'
source ~/.zshrc 2>/dev/null || source ~/.bashrc 2>/dev/null
command -v gstat >/dev/null && echo "✅ Git functions available"
command -v proj-init >/dev/null && echo "✅ Project functions available"
command -v backup >/dev/null && echo "✅ Utility functions available"
[[ -n "$WORKSPACE" ]] && echo "✅ Environment variables set"
EOF
    )
    
    if $SHELL -c "$test_script" | grep -q "✅"; then
        print_success "Installation test passed"
    else
        print_error "Installation test failed"
        return 1
    fi
}

# Print completion message
print_completion() {
    print_header "🎉 Installation Complete!"
    
    echo
    print_success "Enhanced shell configuration installed successfully!"
    echo
    print_color $BLUE "What's been installed:"
    echo "  • Enhanced shell configuration with performance optimizations"
    echo "  • Development functions for Git, Docker, Kubernetes"
    echo "  • Productivity utilities and system monitoring tools"
    echo "  • Smart aliases and tab completions"
    echo "  • Beautiful prompts and welcome messages"
    echo
    print_color $BLUE "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Try: aliases-help (see all available commands)"
    echo "  3. Try: envinfo (system information)"
    echo "  4. Try: gstat (enhanced git status)"
    echo "  5. Try: proj-init myproject node (create new project)"
    echo
    print_color $BLUE "Configuration files:"
    echo "  • Shell config: $HOME/.zshrc (or ~/.bashrc)"
    echo "  • Functions: $HOME/.config/tiation-shell/functions/"
    echo "  • Aliases: $HOME/.config/tiation-shell/tiation-aliases.zsh"
    echo "  • Backups: $BACKUP_DIR"
    echo
    print_color $PURPLE "🌟 Your enhanced shell is ready! Enjoy coding! 🚀"
    echo
}

# Uninstall function
uninstall() {
    print_header "Uninstalling Tiation Shell Configuration"
    
    local shell_type=$(detect_shell)
    local config_file=""
    
    case "$shell_type" in
        "zsh") config_file="$HOME/.zshrc" ;;
        "bash") config_file="$HOME/.bashrc" ;;
    esac
    
    # Remove Tiation additions from config file
    if [[ -f "$config_file" ]] && grep -q "tiation-shell" "$config_file"; then
        print_step "Removing Tiation enhancements from $config_file"
        # Create temp file without Tiation sections
        awk '
        /^# ═══.*Tiation Shell Enhancements/ { skip=1; next }
        /^# ═══/ && skip { skip=0; next }
        !skip { print }
        ' "$config_file" > "${config_file}.tmp"
        
        mv "${config_file}.tmp" "$config_file"
        print_success "Tiation enhancements removed"
    fi
    
    # Remove configuration directory
    if [[ -d "$CONFIG_DIR" ]]; then
        print_step "Removing configuration directory"
        rm -rf "$CONFIG_DIR"
        print_success "Configuration directory removed"
    fi
    
    print_success "Uninstallation complete"
    print_info "Your shell configuration has been restored"
    print_info "Restart your terminal to apply changes"
}

# Main installation function
main() {
    case "${1:-install}" in
        "install")
            print_header "Installing Tiation Enhanced Shell Configuration"
            
            local shell_type=$(detect_shell)
            print_info "Detected shell: $shell_type"
            
            # Run installation steps
            check_dependencies
            backup_existing "$shell_type"
            
            # Shell-specific setup
            if [[ "$shell_type" == "zsh" ]]; then
                setup_oh_my_zsh
                install_spaceship_prompt
            fi
            
            # Install configuration components
            create_shell_aliases
            install_functions
            install_themes
            install_completions
            
            # Update shell configuration
            if [[ -f "$REPO_DIR/configs/.${shell_type}rc" ]]; then
                install_config "$shell_type"
            else
                update_shell_config "$shell_type"
            fi
            
            test_installation
            print_completion
            
            # Optional: set as default shell
            configure_default_shell "$shell_type"
            ;;
            
        "uninstall")
            uninstall
            ;;
            
        "test")
            test_installation
            ;;
            
        "--help"|"-h"|"help")
            echo "Tiation Enhanced Shell Configuration Installer"
            echo
            echo "Usage: $0 [command]"
            echo
            echo "Commands:"
            echo "  install   - Install enhanced shell configuration (default)"
            echo "  uninstall - Remove Tiation shell enhancements"
            echo "  test      - Test current installation"
            echo "  help      - Show this help message"
            echo
            echo "Features:"
            echo "  • Performance-optimized shell startup"
            echo "  • Enhanced Git, Docker, Kubernetes commands"
            echo "  • Development project scaffolding"
            echo "  • System monitoring and productivity tools"
            echo "  • Beautiful prompts and welcome messages"
            echo "  • Smart completions and aliases"
            ;;
            
        *)
            print_error "Unknown command: $1"
            echo "Use '$0 help' for usage information"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
