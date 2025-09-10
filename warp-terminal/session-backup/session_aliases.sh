#!/usr/bin/env bash
# Session Management Aliases
# Add this to your .zshrc or .bashrc: source ~/.warp_session_backups/session_aliases.sh

# Session backup aliases
alias session-backup='$HOME/.warp_session_backups/scripts/backup_session.sh'
alias session-list='$HOME/.warp_session_backups/scripts/restore_session.sh list'
alias session-show='$HOME/.warp_session_backups/scripts/restore_session.sh show'
alias session-restore='$HOME/.warp_session_backups/scripts/restore_session.sh restore'
alias session-script='$HOME/.warp_session_backups/scripts/restore_session.sh script'
alias session-json='$HOME/.warp_session_backups/scripts/restore_session.sh json'

# Quick session operations
alias sb='session-backup'
alias sl='session-list'
alias ss='session-show'
alias sr='session-restore'

# View session logs
alias session-logs='find $HOME/.warp_session_backups/logs -name "*.log" -exec tail -f {} \;'
alias session-today='find $HOME/.warp_session_backups/logs -name "*$(date +%Y-%m-%d)*" -type f'

# Session directory shortcuts
alias session-dir='cd $HOME/.warp_session_backups'
alias session-log-dir='cd $HOME/.warp_session_backups/logs'

echo "Session management aliases loaded!"
echo "Available commands:"
echo "  session-backup  (sb) - Backup current session"
echo "  session-list    (sl) - List all sessions"  
echo "  session-show    (ss) - Show session details"
echo "  session-restore (sr) - Restore session info"
echo "  session-script      - Generate restore script"
echo "  session-json        - View JSON backup"
echo "  session-logs        - View live logs"
echo "  session-today       - Show today's backups"
