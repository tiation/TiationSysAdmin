#!/usr/bin/env bash
set -euo pipefail

# Warp Theme Preview and Validation Script
# Tests and previews themes with sample code and color demonstrations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
error() { printf "\033[1;31m[ERROR]\033[0m %s\n" "$*" >&2; }
success() { printf "\033[1;32m[SUCCESS]\033[0m %s\n" "$*"; }

# Color test function
test_colors() {
    echo "🎨 ANSI Color Test:"
    echo ""
    
    # Basic colors
    for i in {0..7}; do
        printf "\033[3${i}m██\033[0m "
    done
    echo " (Normal)"
    
    # Bright colors
    for i in {0..7}; do
        printf "\033[9${i}m██\033[0m "
    done
    echo " (Bright)"
    
    echo ""
}

# Syntax highlighting demo
show_syntax_demo() {
    echo "💻 Code Syntax Demo:"
    echo ""
    
    cat << 'EOF'
# Python Example
def calculate_fibonacci(n: int) -> int:
    """Calculate nth Fibonacci number recursively."""
    if n <= 1:
        return n
    return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)

# Usage
result = calculate_fibonacci(10)
print(f"The 10th Fibonacci number is: {result}")

// JavaScript Example  
const fetchUserData = async (userId) => {
    try {
        const response = await fetch(`/api/users/${userId}`);
        const userData = await response.json();
        return userData;
    } catch (error) {
        console.error('Error fetching user data:', error);
        throw error;
    }
};

/* CSS Example */
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
    background-color: #f8f9fa;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

# Shell Script Example
#!/bin/bash
for file in *.txt; do
    if [[ -f "$file" ]]; then
        echo "Processing: $file"
        wc -l "$file" >> word_counts.txt
    fi
done
EOF
    echo ""
}

# Git diff demo
show_git_demo() {
    echo "🔄 Git Diff Demo:"
    echo ""
    
    cat << 'EOF'
diff --git a/src/main.py b/src/main.py
index abc1234..def5678 100644
--- a/src/main.py
+++ b/src/main.py
@@ -1,8 +1,10 @@
 def main():
-    print("Hello World")
+    print("Hello, World!")
+    print("Welcome to the new version")
     
     # Configuration
-    config = {"debug": False}
+    config = {
+        "debug": True,
+        "version": "2.0.0"
+    }
     
     return 0
EOF
    echo ""
}

# System info demo
show_system_demo() {
    echo "⚙️  System Command Demo:"
    echo ""
    
    # Show some colorized system info
    printf "\033[1;32m✓\033[0m System: macOS $(sw_vers -productVersion 2>/dev/null || echo "Unknown")\n"
    printf "\033[1;34mℹ\033[0m Shell: $SHELL\n" 
    printf "\033[1;33m⚠\033[0m Memory: $(memory_pressure 2>/dev/null | head -1 || echo "Unknown")\n"
    printf "\033[1;31m✗\033[0m Last error: Exit code 1\n"
    printf "\033[1;36m→\033[0m Current directory: $(pwd)\n"
    
    echo ""
}

# Validate YAML syntax
validate_theme() {
    local theme_file="$1"
    local errors=0
    
    if ! command -v python3 >/dev/null; then
        warn "Python3 not found, skipping YAML validation"
        return 0
    fi
    
    # Basic YAML validation using Python
    if ! python3 -c "
import yaml
import sys
try:
    with open('$theme_file', 'r') as f:
        yaml.safe_load(f)
    print('✓ Valid YAML syntax')
except yaml.YAMLError as e:
    print(f'✗ YAML Error: {e}', file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f'✗ Error: {e}', file=sys.stderr)
    sys.exit(1)
" 2>/dev/null; then
        error "Invalid YAML in $theme_file"
        ((errors++))
    fi
    
    # Check required fields
    local required_fields=("kind" "name" "version" "colors")
    for field in "${required_fields[@]}"; do
        if ! grep -q "^${field}:" "$theme_file"; then
            error "Missing required field: $field in $theme_file"
            ((errors++))
        fi
    done
    
    return $errors
}

# Preview a single theme
preview_theme() {
    local theme_file="$1"
    
    if [[ ! -f "$theme_file" ]]; then
        error "Theme file not found: $theme_file"
        return 1
    fi
    
    local theme_name=$(grep "^name:" "$theme_file" | sed 's/name: *"*\([^"]*\)"*/\1/' | tr -d '"')
    
    echo "════════════════════════════════════════════════════════════════"
    echo "🎨 PREVIEWING THEME: $theme_name"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    
    # Validate theme
    log "Validating theme file..."
    if validate_theme "$theme_file"; then
        success "Theme validation passed"
    else
        warn "Theme validation failed, but continuing preview..."
    fi
    echo ""
    
    # Show theme info
    local description=$(grep "^description:" "$theme_file" | sed 's/description: *"*\([^"]*\)"*/\1/' | tr -d '"')
    if [[ -n "$description" ]]; then
        echo "📝 Description: $description"
        echo ""
    fi
    
    # Show color tests
    test_colors
    show_syntax_demo
    show_git_demo
    show_system_demo
    
    echo "════════════════════════════════════════════════════════════════"
    echo ""
}

# Preview all themes
preview_all() {
    local theme_files=("$SCRIPT_DIR"/*.yaml)
    local count=0
    
    if [[ ! -e "${theme_files[0]}" ]]; then
        error "No theme files found in $SCRIPT_DIR"
        return 1
    fi
    
    for theme_file in "${theme_files[@]}"; do
        if [[ -f "$theme_file" ]]; then
            preview_theme "$theme_file"
            ((count++))
            
            # Ask to continue if not the last file
            if [[ $count -lt ${#theme_files[@]} ]]; then
                printf "\033[1;36mPress Enter to continue to next theme, or 'q' to quit: \033[0m"
                read -r response
                if [[ "$response" == "q" ]]; then
                    break
                fi
                clear
            fi
        fi
    done
    
    success "Previewed $count themes"
}

# List available themes
list_themes() {
    echo "🎨 Available Themes:"
    echo ""
    
    for theme_file in "$SCRIPT_DIR"/*.yaml; do
        if [[ -f "$theme_file" ]]; then
            local name=$(grep "^name:" "$theme_file" | sed 's/name: *"*\([^"]*\)"*/\1/' | tr -d '"')
            local desc=$(grep "^description:" "$theme_file" | sed 's/description: *"*\([^"]*\)"*/\1/' | tr -d '"')
            local filename=$(basename "$theme_file")
            
            printf "  \033[1;32m%-30s\033[0m %s\n" "$name" "($filename)"
            if [[ -n "$desc" ]]; then
                printf "    \033[2m%s\033[0m\n" "$desc"
            fi
            echo ""
        fi
    done
}

# Show help
show_help() {
    cat << 'EOF'
🎨 Warp Theme Preview and Validation Tool

Usage: ./preview-themes.sh [options] [theme_file]

Options:
    -h, --help          Show this help message
    -l, --list          List all available themes
    -a, --all           Preview all themes interactively
    -v, --validate      Validate theme files only (no preview)
    
Arguments:
    theme_file          Specific theme file to preview

Examples:
    ./preview-themes.sh                                    # Preview all themes
    ./preview-themes.sh tiation-default-dark.yaml        # Preview specific theme
    ./preview-themes.sh --list                            # List available themes
    ./preview-themes.sh --validate                        # Validate all themes

This script helps you:
• Validate YAML syntax and required fields
• Preview color schemes with sample code
• Test ANSI color support
• View syntax highlighting examples
• Demonstrate Git diff colors
• Show system status colors

EOF
}

# Main execution
main() {
    case "${1:-}" in
        -h|--help)
            show_help
            ;;
        -l|--list)
            list_themes
            ;;
        -a|--all)
            preview_all
            ;;
        -v|--validate)
            log "Validating all themes..."
            local errors=0
            for theme_file in "$SCRIPT_DIR"/*.yaml; do
                if [[ -f "$theme_file" ]]; then
                    printf "Checking %s: " "$(basename "$theme_file")"
                    if validate_theme "$theme_file"; then
                        success "✓"
                    else
                        ((errors++))
                    fi
                fi
            done
            if [[ $errors -eq 0 ]]; then
                success "All themes validated successfully"
            else
                error "$errors theme(s) have validation errors"
                exit 1
            fi
            ;;
        *.yaml)
            preview_theme "$1"
            ;;
        "")
            preview_all
            ;;
        *)
            error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
