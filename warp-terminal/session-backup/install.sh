#!/usr/bin/env bash
set -euo pipefail

# Warp Terminal Session Backup System Installer
# This script installs and configures the session backup system

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.warp_session_backups"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WARP_DB="$HOME/Library/Application Support/dev.warp.Warp-Stable/warp.sqlite"

print_color() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

print_header() {
    echo
    print_color $BLUE "================================"
    print_color $BLUE "$1"
    print_color $BLUE "================================"
}

print_step() {
    print_color $YELLOW "➤ $1"
}

print_success() {
    print_color $GREEN "✓ $1"
}

print_error() {
    print_color $RED "✗ $1"
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check if sqlite3 is available
    if ! command -v sqlite3 >/dev/null 2>&1; then
        print_error "sqlite3 is required but not installed."
        exit 1
    fi
    print_success "sqlite3 found"
    
    # Check if cron service is available (macOS)
    if ! launchctl list | grep -q cron 2>/dev/null; then
        print_color $YELLOW "Warning: cron service not found. Manual setup may be required."
    else
        print_success "cron service available"
    fi
}

# Create installation directory structure
create_directories() {
    print_header "Creating Directory Structure"
    
    print_step "Creating $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/scripts"
    mkdir -p "$INSTALL_DIR/logs"
    mkdir -p "$INSTALL_DIR/db_backups"
    print_success "Directories created"
}

# Install scripts
install_scripts() {
    print_header "Installing Scripts"
    
    print_step "Copying backup script"
    cp "$REPO_DIR/scripts/backup_session.sh" "$INSTALL_DIR/scripts/"
    chmod +x "$INSTALL_DIR/scripts/backup_session.sh"
    print_success "Backup script installed"
    
    print_step "Copying restore script"
    cp "$REPO_DIR/scripts/restore_session.sh" "$INSTALL_DIR/scripts/"
    chmod +x "$INSTALL_DIR/scripts/restore_session.sh"
    print_success "Restore script installed"
    
    print_step "Copying session aliases"
    cp "$REPO_DIR/session_aliases.sh" "$INSTALL_DIR/"
    print_success "Session aliases installed"
}

# Setup database
setup_database() {
    print_header "Setting Up Database"
    
    if [[ ! -f "$WARP_DB" ]]; then
        print_step "Creating Warp database directory"
        mkdir -p "$(dirname "$WARP_DB")"
    fi
    
    print_step "Creating database tables"
    sqlite3 "$WARP_DB" "
    CREATE TABLE IF NOT EXISTS sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_name TEXT NOT NULL,
        working_directory TEXT NOT NULL,
        command_history TEXT,
        environment_vars TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        last_accessed DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    
    CREATE TABLE IF NOT EXISTS session_tabs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        tab_name TEXT,
        working_directory TEXT NOT NULL,
        current_command TEXT,
        tab_order INTEGER,
        FOREIGN KEY (session_id) REFERENCES sessions(id)
    );" 2>/dev/null || {
        print_error "Failed to create database tables"
        exit 1
    }
    print_success "Database tables created"
}

# Setup cron job
setup_cron() {
    print_header "Setting Up Cron Job"
    
    # Check if cron job already exists
    if crontab -l 2>/dev/null | grep -q "backup_session.sh"; then
        print_color $YELLOW "Cron job already exists, skipping..."
        return
    fi
    
    print_step "Adding cron job for session backups (every 5 minutes)"
    
    # Get current crontab and add our job
    (crontab -l 2>/dev/null || echo "") | {
        cat
        echo ""
        echo "# Warp Session Backup - runs every 5 minutes"
        echo "*/5 * * * * $INSTALL_DIR/scripts/backup_session.sh >/dev/null 2>&1"
    } | crontab -
    
    print_success "Cron job added"
}

# Setup shell aliases
setup_aliases() {
    print_header "Setting Up Shell Aliases"
    
    # Detect shell
    local shell_rc=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_rc="$HOME/.bashrc"
    else
        print_error "Unsupported shell: $SHELL"
        print_color $YELLOW "Please manually add the following line to your shell configuration:"
        print_color $YELLOW "source $INSTALL_DIR/session_aliases.sh"
        return
    fi
    
    # Check if already added
    if grep -q "session_aliases.sh" "$shell_rc" 2>/dev/null; then
        print_color $YELLOW "Aliases already added to $shell_rc, skipping..."
        return
    fi
    
    print_step "Adding aliases to $shell_rc"
    echo "" >> "$shell_rc"
    echo "# Warp Session Management Aliases" >> "$shell_rc"
    echo "source $INSTALL_DIR/session_aliases.sh" >> "$shell_rc"
    print_success "Aliases added to $shell_rc"
}

# Test installation
test_installation() {
    print_header "Testing Installation"
    
    print_step "Running backup script test"
    "$INSTALL_DIR/scripts/backup_session.sh" || {
        print_error "Backup script test failed"
        exit 1
    }
    print_success "Backup script test passed"
    
    print_step "Testing restore script"
    "$INSTALL_DIR/scripts/restore_session.sh" list >/dev/null || {
        print_error "Restore script test failed"
        exit 1
    }
    print_success "Restore script test passed"
    
    print_step "Checking cron job"
    if crontab -l 2>/dev/null | grep -q "backup_session.sh"; then
        print_success "Cron job configured"
    else
        print_color $YELLOW "Warning: Cron job not found"
    fi
}

# Print completion message
print_completion() {
    print_header "Installation Complete!"
    
    echo
    print_color $GREEN "The Warp session backup system has been installed successfully!"
    echo
    print_color $BLUE "What's been set up:"
    echo "  • Session backup scripts in $INSTALL_DIR"
    echo "  • Cron job running every 5 minutes"
    echo "  • Database tables in Warp SQLite database"
    echo "  • Shell aliases for easy access"
    echo
    print_color $BLUE "Available commands (restart your shell first):"
    echo "  session-list    (sl) - List all sessions"
    echo "  session-show    (ss) - Show session details"
    echo "  session-restore (sr) - Restore session info"
    echo "  session-backup  (sb) - Manual backup"
    echo
    print_color $BLUE "Getting started:"
    echo "  1. Restart your shell or run: source $INSTALL_DIR/session_aliases.sh"
    echo "  2. Try: sl (to list sessions)"
    echo "  3. Try: sb (to backup current session)"
    echo
    print_color $BLUE "Documentation:"
    echo "  • README: $REPO_DIR/docs/README.md"
    echo "  • Scripts: $INSTALL_DIR/scripts/"
    echo "  • Logs: $INSTALL_DIR/logs/"
    echo
    print_color $GREEN "Your terminal sessions are now being automatically backed up!"
}

# Uninstall function
uninstall() {
    print_header "Uninstalling Warp Session Backup System"
    
    print_step "Removing installation directory"
    rm -rf "$INSTALL_DIR"
    print_success "Installation directory removed"
    
    print_step "Removing cron job"
    crontab -l 2>/dev/null | grep -v "backup_session.sh" | crontab - 2>/dev/null || true
    print_success "Cron job removed"
    
    print_color $YELLOW "Note: Shell aliases will be removed on next shell restart"
    print_color $YELLOW "To remove immediately, edit your ~/.zshrc or ~/.bashrc file"
    
    print_success "Uninstallation complete"
}

# Main installation function
main() {
    print_header "Warp Terminal Session Backup System Installer"
    
    case "${1:-install}" in
        "install")
            check_prerequisites
            create_directories
            install_scripts
            setup_database
            setup_cron
            setup_aliases
            test_installation
            print_completion
            ;;
        "uninstall")
            uninstall
            ;;
        "test")
            test_installation
            ;;
        "--help"|"-h"|"help")
            echo "Usage: $0 [install|uninstall|test|help]"
            echo
            echo "Commands:"
            echo "  install   - Install the session backup system (default)"
            echo "  uninstall - Remove the session backup system"
            echo "  test      - Test the current installation"
            echo "  help      - Show this help message"
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
