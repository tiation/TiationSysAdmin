#!/usr/bin/env bash
set -euo pipefail

# Configuration
WARP_DB="$HOME/Library/Application Support/dev.warp.Warp-Stable/warp.sqlite"
BACKUP_DIR="$HOME/.warp_session_backups"
LOG_DIR="$BACKUP_DIR/logs"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Function to list available sessions
list_sessions() {
    print_color $BLUE "=== Available Sessions ==="
    
    if [[ -f "$WARP_DB" ]]; then
        sqlite3 "$WARP_DB" -header -column "
        SELECT 
            id,
            session_name,
            working_directory,
            created_at,
            last_accessed
        FROM sessions 
        ORDER BY last_accessed DESC
        LIMIT 20;" 2>/dev/null || {
            print_color $YELLOW "No sessions found in database"
        }
    else
        print_color $RED "Database not found: $WARP_DB"
    fi
    
    echo
    print_color $BLUE "=== Available JSON Backups ==="
    find "$LOG_DIR" -name "session_*.json" -exec basename {} \; 2>/dev/null | sort -r | head -20 || {
        print_color $YELLOW "No JSON backup files found"
    }
}

# Function to show session details
show_session_details() {
    local session_id=$1
    
    if [[ -f "$WARP_DB" ]]; then
        print_color $GREEN "Session Details:"
        sqlite3 "$WARP_DB" -header -column "
        SELECT * FROM sessions WHERE id = $session_id;" 2>/dev/null || {
            print_color $RED "Session ID $session_id not found"
            return 1
        }
        
        echo
        print_color $GREEN "Command History:"
        sqlite3 "$WARP_DB" "
        SELECT command_history FROM sessions WHERE id = $session_id;" 2>/dev/null | tr '|' '\n'
        
        echo
        print_color $GREEN "Environment Variables:"
        sqlite3 "$WARP_DB" "
        SELECT environment_vars FROM sessions WHERE id = $session_id;" 2>/dev/null | tr '|' '\n'
    else
        print_color $RED "Database not found"
        return 1
    fi
}

# Function to show JSON backup details
show_json_backup() {
    local backup_file="$LOG_DIR/$1"
    
    if [[ -f "$backup_file" ]]; then
        print_color $GREEN "JSON Backup Contents:"
        cat "$backup_file" | jq '.' 2>/dev/null || cat "$backup_file"
    else
        print_color $RED "Backup file not found: $backup_file"
        return 1
    fi
}

# Function to restore session to current directory
restore_session_here() {
    local session_id=$1
    
    if [[ ! -f "$WARP_DB" ]]; then
        print_color $RED "Database not found"
        return 1
    fi
    
    local session_info=$(sqlite3 "$WARP_DB" "
    SELECT session_name, working_directory, command_history, environment_vars 
    FROM sessions WHERE id = $session_id;" 2>/dev/null)
    
    if [[ -z "$session_info" ]]; then
        print_color $RED "Session ID $session_id not found"
        return 1
    fi
    
    local session_name=$(echo "$session_info" | cut -d'|' -f1)
    local working_dir=$(echo "$session_info" | cut -d'|' -f2)
    local command_hist=$(echo "$session_info" | cut -d'|' -f3)
    local env_vars=$(echo "$session_info" | cut -d'|' -f4)
    
    print_color $GREEN "Restoring session: $session_name"
    print_color $YELLOW "Original directory: $working_dir"
    print_color $YELLOW "Current directory: $(pwd)"
    
    echo
    print_color $BLUE "Recent commands from this session:"
    echo "$command_hist" | tr '|' '\n' | head -10
    
    echo
    print_color $BLUE "Environment variables from this session:"
    echo "$env_vars" | tr '|' '\n' | head -10
    
    # Update the session's last accessed time
    sqlite3 "$WARP_DB" "
    UPDATE sessions 
    SET last_accessed = datetime('now') 
    WHERE id = $session_id;" 2>/dev/null
    
    print_color $GREEN "Session information displayed. You may want to:"
    echo "1. cd '$working_dir' - to go to the original directory"
    echo "2. Check the command history above for useful commands"
    echo "3. Set any needed environment variables"
}

# Function to generate a restore script
generate_restore_script() {
    local session_id=$1
    local output_file="$BACKUP_DIR/restore_${session_id}_$(date +%Y%m%d_%H%M%S).sh"
    
    if [[ ! -f "$WARP_DB" ]]; then
        print_color $RED "Database not found"
        return 1
    fi
    
    local session_info=$(sqlite3 "$WARP_DB" "
    SELECT session_name, working_directory, command_history, environment_vars 
    FROM sessions WHERE id = $session_id;" 2>/dev/null)
    
    if [[ -z "$session_info" ]]; then
        print_color $RED "Session ID $session_id not found"
        return 1
    fi
    
    local session_name=$(echo "$session_info" | cut -d'|' -f1)
    local working_dir=$(echo "$session_info" | cut -d'|' -f2)
    local command_hist=$(echo "$session_info" | cut -d'|' -f3)
    local env_vars=$(echo "$session_info" | cut -d'|' -f4)
    
    cat > "$output_file" <<EOF
#!/usr/bin/env bash
# Restore script for session: $session_name
# Generated on: $(date)

echo "Restoring session: $session_name"

# Change to original directory
if [[ -d "$working_dir" ]]; then
    cd "$working_dir"
    echo "Changed to directory: $working_dir"
else
    echo "Warning: Original directory not found: $working_dir"
    echo "Current directory: \$(pwd)"
fi

# Environment variables from session
echo "Setting environment variables..."
$(echo "$env_vars" | tr '|' '\n' | sed 's/^/export /')

echo "Session restored! Recent commands were:"
$(echo "$command_hist" | tr '|' '\n' | sed 's/^/# /')

echo ""
echo "You can now run any of the above commands or continue working."
EOF
    
    chmod +x "$output_file"
    print_color $GREEN "Restore script generated: $output_file"
    print_color $YELLOW "Run with: bash '$output_file'"
}

# Function to show usage
usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  list                    - List available sessions and backups"
    echo "  show <session_id>       - Show details of a specific session"
    echo "  json <backup_filename>  - Show JSON backup file contents"
    echo "  restore <session_id>    - Restore session information (display only)"
    echo "  script <session_id>     - Generate a restore script"
    echo ""
    echo "Examples:"
    echo "  $0 list"
    echo "  $0 show 1"
    echo "  $0 json session_2025-09-10_04-30-15.json"
    echo "  $0 restore 1"
    echo "  $0 script 1"
}

# Main script logic
case "${1:-}" in
    "list"|"ls")
        list_sessions
        ;;
    "show"|"details")
        if [[ -z "${2:-}" ]]; then
            print_color $RED "Error: Please provide a session ID"
            echo "Usage: $0 show <session_id>"
            exit 1
        fi
        show_session_details "$2"
        ;;
    "json"|"backup")
        if [[ -z "${2:-}" ]]; then
            print_color $RED "Error: Please provide a backup filename"
            echo "Usage: $0 json <backup_filename>"
            exit 1
        fi
        show_json_backup "$2"
        ;;
    "restore")
        if [[ -z "${2:-}" ]]; then
            print_color $RED "Error: Please provide a session ID"
            echo "Usage: $0 restore <session_id>"
            exit 1
        fi
        restore_session_here "$2"
        ;;
    "script"|"generate")
        if [[ -z "${2:-}" ]]; then
            print_color $RED "Error: Please provide a session ID"
            echo "Usage: $0 script <session_id>"
            exit 1
        fi
        generate_restore_script "$2"
        ;;
    "help"|"-h"|"--help"|*)
        usage
        ;;
esac
