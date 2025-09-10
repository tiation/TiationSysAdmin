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

# List available themes
list_themes() {
    echo "🎨 Available Themes:"
    echo ""
    
    local themes=(
        "tiation-default-dark.yaml|Professional dark theme for extended coding"
        "tiation-default-light.yaml|Clean light theme for bright environments"
        "tiation-high-contrast-dark.yaml|High contrast dark for accessibility"
        "tiation-high-contrast-light.yaml|High contrast light for accessibility"
        "tiation-dimmed-dark.yaml|Ultra-low intensity for late-night coding"
    )
    
    for theme_info in "${themes[@]}"; do
        IFS='|' read -r filename description <<< "$theme_info"
        if [[ -f "$SCRIPT_DIR/$filename" ]]; then
            printf "  ✓ \033[1;32m%-35s\033[0m %s\n" "${filename%%.yaml}" "$description"
        else
            printf "  ✗ \033[1;31m%-35s\033[0m %s (missing)\n" "${filename%%.yaml}" "$description"
        fi
    done
    echo ""
}

# Install theme files with user selection
install_themes() {
    local count=0
    local theme_files=("$SCRIPT_DIR"/*.yaml)
    local install_mode="${1:-all}"
    
    if [[ ! -e "${theme_files[0]}" ]]; then
        error "No theme files found in $SCRIPT_DIR"
        return 1
    fi
    
    # Interactive mode
    if [[ "$install_mode" == "interactive" ]]; then
        echo "🎨 Theme Installation Options:"
        echo "1. Install all themes (recommended)"
        echo "2. Install basic themes only (default dark + light)"
        echo "3. Install accessibility themes only (high contrast)"
        echo "4. Choose specific themes"
        echo ""
        printf "Select option (1-4) [1]: "
        read -r choice
        choice=${choice:-1}
        
        case $choice in
            1) install_mode="all" ;;
            2) install_mode="basic" ;;
            3) install_mode="accessibility" ;;
            4) install_mode="custom" ;;
            *) install_mode="all" ;;
        esac
    fi
    
    # Determine which themes to install
    local themes_to_install=()
    case $install_mode in
        "basic")
            themes_to_install=("tiation-default-dark.yaml" "tiation-default-light.yaml")
            ;;
        "accessibility")
            themes_to_install=("tiation-high-contrast-dark.yaml" "tiation-high-contrast-light.yaml")
            ;;
        "custom")
            echo "\n📋 Available themes:"
            local i=1
            for theme_file in "${theme_files[@]}"; do
                if [[ -f "$theme_file" ]]; then
                    local name=$(grep "^name:" "$theme_file" | sed 's/name: *"*\([^"]*\)"*/\1/' | tr -d '"')
                    printf "  %d. %s\n" $i "$name"
                    ((i++))
                fi
            done
            echo ""
            printf "Enter theme numbers (space-separated) or 'all': "
            read -r selection
            # Custom selection logic would go here
            themes_to_install=("${theme_files[@]}")
            ;;
        *)
            themes_to_install=("${theme_files[@]}")
            ;;
    esac
    
    # Install selected themes
    for theme_file in "${themes_to_install[@]}"; do
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
   • Tiation Default Dark - Professional dark theme
   • Tiation Default Light - Clean light theme
   • Tiation High Contrast Dark - Accessibility-focused dark
   • Tiation High Contrast Light - Accessibility-focused light
   • Tiation Dimmed Dark - Ultra-low intensity for night coding
5. Press the checkmark to save

💡 Recommended Setup: Enable OS Theme Sync
1. In Settings > Appearance, toggle "Sync with OS"
2. Configure automatic switching:
   • Light mode → Tiation Default Light (or High Contrast Light)
   • Dark mode → Tiation Default Dark (or High Contrast Dark)
3. Your themes will automatically switch with your system!

🎨 Theme Selection Guide:
• Default themes: Everyday coding, balanced colors
• High Contrast themes: Visual impairments, bright environments
• Dimmed themes: Late-night coding, reduce eye strain

🔧 Testing Your Themes:
Run ./preview-themes.sh to test colors and validate themes

📚 Documentation:
See README.md for detailed theme information and troubleshooting

EOF
}

# Show help
show_help() {
    cat << 'EOF'
🎨 Tiation Warp Themes Installer

Usage: ./install-themes.sh [options]

Options:
    -h, --help           Show this help message
    -l, --list           List all available themes
    -i, --interactive    Interactive installation mode
    -b, --basic          Install basic themes only (default dark + light)
    -a, --accessibility  Install high-contrast accessibility themes only
    --preview           Preview themes before installation
    --validate          Validate theme files before installation

Examples:
    ./install-themes.sh                    # Install all themes
    ./install-themes.sh --interactive      # Choose installation options
    ./install-themes.sh --basic           # Install default themes only
    ./install-themes.sh --list            # List available themes

This installer:
• Checks for Warp Terminal installation
• Creates ~/.warp/themes directory if needed
• Backs up existing themes before overwriting
• Provides setup guidance for OS theme sync
• Supports multiple installation modes

EOF
}

# Main installation flow
main() {
    local mode="all"
    
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_themes
            exit 0
            ;;
        -i|--interactive)
            mode="interactive"
            ;;
        -b|--basic)
            mode="basic"
            ;;
        -a|--accessibility)
            mode="accessibility"
            ;;
        --preview)
            if [[ -x "$SCRIPT_DIR/preview-themes.sh" ]]; then
                "$SCRIPT_DIR/preview-themes.sh" --list
                printf "\n\033[1;36mContinue with installation? (y/N): \033[0m"
                read -r response
                if [[ "$response" != [yY] ]]; then
                    echo "Installation cancelled."
                    exit 0
                fi
            else
                warn "Preview script not found, continuing with installation..."
            fi
            ;;
        --validate)
            if [[ -x "$SCRIPT_DIR/preview-themes.sh" ]]; then
                "$SCRIPT_DIR/preview-themes.sh" --validate
                exit $?
            else
                error "Preview script not found for validation"
                exit 1
            fi
            ;;
        "")
            # Default installation
            ;;
        *)
            error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
    
    log "Starting Tiation Warp Themes installation..."
    
    check_warp || exit 1
    setup_themes_dir || exit 1
    install_themes "$mode" || exit 1
    print_instructions
    
    success "Installation complete! 🎨"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
