#!/usr/bin/env bash
set -euo pipefail

# Configuration
WARP_DB="$HOME/Library/Application Support/dev.warp.Warp-Stable/warp.sqlite"
BACKUP_DIR="$HOME/.warp_session_backups"
LOG_DIR="$BACKUP_DIR/logs"
DATE=$(date "+%Y-%m-%d")
DATETIME=$(date "+%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/session_backup_$DATE.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Function to get current working directory
get_current_pwd() {
    pwd
}

# Function to get recent command history
get_recent_history() {
    # Get last 50 commands from history
    fc -l -50 2>/dev/null | tail -50 || echo "No history available"
}

# Function to get current environment variables (filtered)
get_environment() {
    # Get important environment variables, excluding sensitive ones
    env | grep -E '^(PATH|HOME|USER|SHELL|TERM|PWD|OLDPWD|LANG|LC_)' | head -20
}

# Function to capture current session state
capture_session_state() {
    local current_pwd=$(get_current_pwd)
    local session_name="${USER}_$(basename "$current_pwd")_$DATETIME"
    local command_hist=$(get_recent_history | sed 's/"/\\"/g' | tr '\n' '|')
    local env_vars=$(get_environment | sed 's/"/\\"/g' | tr '\n' '|')
    
    log "Capturing session state for: $session_name"
    log "Working directory: $current_pwd"
    
    # Insert into SQLite database
    sqlite3 "$WARP_DB" "
    INSERT OR REPLACE INTO sessions (
        session_name, 
        working_directory, 
        command_history, 
        environment_vars,
        created_at,
        last_accessed
    ) VALUES (
        '$session_name',
        '$current_pwd',
        '$command_hist',
        '$env_vars',
        datetime('now'),
        datetime('now')
    );" 2>/dev/null || log "Error: Could not write to SQLite database"
    
    # Create dated backup file
    local backup_file="$LOG_DIR/session_${DATETIME}.json"
    cat > "$backup_file" <<EOF
{
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "session_name": "$session_name",
    "working_directory": "$current_pwd",
    "command_history": [
$(get_recent_history | sed 's/.*/"&",/' | sed '$s/,$//')
    ],
    "environment_variables": {
$(get_environment | sed 's/\(.*\)=\(.*\)/        "\1": "\2",/' | sed '$s/,$//')
    },
    "process_info": {
        "shell": "$SHELL",
        "term": "$TERM",
        "user": "$USER",
        "hostname": "$(hostname)"
    }
}
EOF
    
    log "Session backed up to: $backup_file"
    
    # Also create a human-readable log entry
    cat >> "$LOG_DIR/session_activity_$DATE.txt" <<EOF

=== Session Backup: $DATETIME ===
Working Directory: $current_pwd
Session Name: $session_name

Recent Commands:
$(get_recent_history)

Environment Variables:
$(get_environment)

---

EOF
    
    log "Session backup completed successfully"
}

# Function to clean old backups (keep last 30 days)
cleanup_old_backups() {
    log "Cleaning up old backups (keeping last 30 days)"
    find "$LOG_DIR" -name "session_*.json" -mtime +30 -delete 2>/dev/null || true
    find "$LOG_DIR" -name "session_activity_*.txt" -mtime +30 -delete 2>/dev/null || true
    find "$LOG_DIR" -name "session_backup_*.log" -mtime +30 -delete 2>/dev/null || true
}

# Function to create database backup
backup_database() {
    local db_backup_dir="$BACKUP_DIR/db_backups"
    mkdir -p "$db_backup_dir"
    
    if [[ -f "$WARP_DB" && -s "$WARP_DB" ]]; then
        cp "$WARP_DB" "$db_backup_dir/warp_backup_$DATETIME.sqlite" 2>/dev/null || {
            log "Warning: Could not backup database file"
        }
        
        # Keep only last 7 database backups
        find "$db_backup_dir" -name "warp_backup_*.sqlite" | sort | head -n -7 | xargs rm -f 2>/dev/null || true
    fi
}

# Main execution
main() {
    log "Starting session backup process"
    
    # Check if database exists
    if [[ ! -f "$WARP_DB" ]]; then
        log "Warning: Warp database not found at $WARP_DB"
        log "Creating database with required tables..."
        
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
        );" || log "Error: Could not create database tables"
    fi
    
    # Capture current session
    capture_session_state
    
    # Backup database
    backup_database
    
    # Cleanup old files
    cleanup_old_backups
    
    log "Session backup process completed"
}

# Run main function
main "$@"
