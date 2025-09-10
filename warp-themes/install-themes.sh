#!/usr/bin/env bash
set -euo pipefail

# Tiation Warp Themes Installer
# Installs custom Warp terminal themes

THEMES_DIR="$HOME/.warp/themes"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
error() { printf "\033[1;31m[ERROR]\033[0m %s\n" "$*" >&2; }
success() { printf "\033[1;32m[SUCCESS]\033[0m %s\n" "$*"; }

# Check if Warp is installed
check_warp() {
    if [[ ! -d "$HOME/Applications/Warp.app" && ! -d "/Applications/Warp.app" ]]; then
        error "Warp Terminal not found. Please install Warp first:"
        error "https://www.warp.dev/"
        return 1
    fi
    log "Warp Terminal found ✓"
}

# Create themes directory if it doesn't exist
setup_themes_dir() {
    if [[ ! -d "$THEMES_DIR" ]]; then
        log "Creating themes directory: $THEMES_DIR"
        mkdir -p "$THEMES_DIR"
    fi
    log "Themes directory ready ✓"
}

# Install theme files
install_themes() {
    local count=0
    local theme_files=("$SCRIPT_DIR"/*.yaml)
    
    if [[ ! -e "${theme_files[0]}" ]]; then
        error "No theme files found in $SCRIPT_DIR"
        return 1
    fi
    
    for theme_file in "${theme_files[@]}"; do
        if [[ -f "$theme_file" ]]; then
            local filename=$(basename "$theme_file")
            local target="$THEMES_DIR/$filename"
            
            if [[ -f "$target" ]]; then
                warn "Theme already exists: $filename (backing up)"
                cp "$target" "${target}.backup.$(date +%s)"
            fi
            
            cp "$theme_file" "$target"
            log "Installed: $filename"
            ((count++))
        fi
    done
    
    if [[ $count -eq 0 ]]; then
        error "No themes were installed"
        return 1
    fi
    
    success "Successfully installed $count theme(s)"
}

# Print usage instructions
print_instructions() {
    cat << 'EOF'

📖 Next Steps:
1. Open Warp Terminal
2. Go to Settings > Appearance (or press Cmd + ,)
3. Click the "Custom Themes" box
4. Select your preferred theme:
   • Tiation Default Dark (for dark mode)
   • Tiation Default Light (for light mode)
5. Press the checkmark to save

💡 Pro Tip: Enable OS Theme Sync
1. In Settings > Appearance, toggle "Sync with OS"
2. Set Light mode: Tiation Default Light
3. Set Dark mode: Tiation Default Dark

Your themes will now automatically switch with your system theme!

EOF
}

# Main installation flow
main() {
    log "Starting Tiation Warp Themes installation..."
    
    check_warp || exit 1
    setup_themes_dir || exit 1
    install_themes || exit 1
    print_instructions
    
    success "Installation complete! 🎨"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
