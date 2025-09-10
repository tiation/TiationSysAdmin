# Warp Terminal Session Backup & Restore System

A comprehensive session management system that automatically backs up your terminal sessions and allows you to restore them later.

## 🚀 Quick Install

```bash
# Clone the repository
git clone https://github.com/tiation/TiationSysAdmin.git
cd TiationSysAdmin/warp-terminal/session-backup

# Run the installer
./install.sh

# Or for a custom installation
./install.sh install
```

## 🚀 Quick Start (After Installation)

```bash
# Restart your shell or load aliases manually
source ~/.warp_session_backups/session_aliases.sh

# List all sessions
session-list    # or just: sl

# Show details of a specific session
session-show 1  # or just: ss 1

# Manually backup current session
session-backup  # or just: sb

# Restore session information
session-restore 1  # or just: sr 1
```

## 🛠️ Installation Options

### Automatic Installation (Recommended)
The installer script handles everything automatically:
```bash
cd /path/to/TiationSysAdmin/warp-terminal/session-backup
./install.sh
```

### Manual Installation
If you prefer manual setup:
```bash
# 1. Copy scripts to your home directory
cp -r scripts ~/.warp_session_backups/scripts/
cp session_aliases.sh ~/.warp_session_backups/

# 2. Make scripts executable
chmod +x ~/.warp_session_backups/scripts/*.sh

# 3. Add cron job
(crontab -l 2>/dev/null; echo "*/5 * * * * ~/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1") | crontab -

# 4. Add aliases to your shell
echo 'source ~/.warp_session_backups/session_aliases.sh' >> ~/.zshrc
```

### Uninstallation
```bash
./install.sh uninstall
```

## 📁 Repository Structure

### Repository Layout
```
TiationSysAdmin/warp-terminal/session-backup/
├── scripts/
│   ├── backup_session.sh      # Main backup script
│   └── restore_session.sh     # Session restore script
├── docs/
│   └── README.md             # This documentation
├── examples/                  # Example configurations
├── session_aliases.sh        # Convenience aliases
└── install.sh               # Automated installer
```

### Installation Directory (after running installer)
```
~/.warp_session_backups/
├── scripts/
│   ├── backup_session.sh      # Main backup script
│   └── restore_session.sh     # Session restore script
├── logs/                      # All backup files (created at runtime)
│   ├── session_*.json         # JSON backup files
│   ├── session_activity_*.txt # Human-readable logs
│   └── session_backup_*.log   # Script execution logs
├── db_backups/               # SQLite database backups (created at runtime)
└── session_aliases.sh        # Convenience aliases
```

## ⚙️ Features

### Automatic Backups
- **Cron Job**: Runs every 5 minutes automatically
- **SQLite Database**: Stores structured session data
- **JSON Backups**: Individual dated backup files
- **Log Files**: Human-readable session activity logs

### What Gets Backed Up
- Current working directory
- Command history (last 50 commands)
- Environment variables (filtered for security)
- Session metadata (timestamps, user info)
- Process information

### Backup Schedule
The system runs automatically every 5 minutes via cron:
```bash
*/5 * * * * /Users/tiaastor/.warp_session_backups/scripts/backup_session.sh >/dev/null 2>&1
```

## 📋 Commands

### Basic Commands
| Command | Alias | Description |
|---------|-------|-------------|
| `session-backup` | `sb` | Backup current session |
| `session-list` | `sl` | List all sessions |
| `session-show` | `ss` | Show session details |
| `session-restore` | `sr` | Restore session info |

### Advanced Commands
| Command | Description |
|---------|-------------|
| `session-script` | Generate executable restore script |
| `session-json` | View JSON backup file |
| `session-logs` | View live backup logs |
| `session-today` | Show today's backup files |

### Directory Shortcuts
| Command | Description |
|---------|-------------|
| `session-dir` | Navigate to backup directory |
| `session-log-dir` | Navigate to logs directory |

## 💡 Usage Examples

### List Recent Sessions
```bash
session-list
# Shows database sessions + JSON backups
```

### View Session Details
```bash
session-show 2
# Shows detailed info for session ID 2
```

### Generate Restore Script
```bash
session-script 2
# Creates executable script to restore session 2
```

### View JSON Backup
```bash
session-json session_2025-09-10_12-34-13.json
# Shows formatted JSON backup
```

### Manual Backup
```bash
session-backup
# Force backup current session
```

## 🔧 Configuration

### Backup Frequency
To change backup frequency, edit the cron job:
```bash
crontab -e
```

Current setting: Every 5 minutes
- For every 10 minutes: `*/10 * * * *`
- For hourly: `0 * * * *`
- For daily at 9 AM: `0 9 * * *`

### Cleanup Settings
The system automatically cleans up old files:
- **JSON/Log files**: Keep for 30 days
- **Database backups**: Keep last 7 copies

### Database Location
Sessions are stored in the Warp SQLite database:
```
~/Library/Application Support/dev.warp.Warp-Stable/warp.sqlite
```

## 📊 Database Schema

### `sessions` table
```sql
CREATE TABLE sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_name TEXT NOT NULL,
    working_directory TEXT NOT NULL,
    command_history TEXT,
    environment_vars TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_accessed DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### `session_tabs` table
```sql
CREATE TABLE session_tabs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    tab_name TEXT,
    working_directory TEXT NOT NULL,
    current_command TEXT,
    tab_order INTEGER,
    FOREIGN KEY (session_id) REFERENCES sessions(id)
);
```

## 🔍 Monitoring

### Check Cron Job Status
```bash
crontab -l
# Verify backup job is listed
```

### View Backup Logs
```bash
session-logs
# Watch live backup activity
```

### View Today's Activity
```bash
session-today
# List all backup files from today
```

## 🛠️ Troubleshooting

### Cron Job Not Running
```bash
# Check if cron service is running
sudo launchctl list | grep cron

# View system logs for cron
tail -f /var/log/system.log | grep cron
```

### Database Issues
```bash
# Check if database exists and has tables
sqlite3 "$HOME/Library/Application Support/dev.warp.Warp-Stable/warp.sqlite" ".tables"

# Recreate tables if needed
session-backup
```

### Permission Issues
```bash
# Make scripts executable
chmod +x ~/.warp_session_backups/scripts/*.sh
```

## 📝 File Formats

### JSON Backup Format
```json
{
    "timestamp": "2025-09-10T04:34:13Z",
    "session_name": "tiaastor_project_2025-09-10_12-34-13",
    "working_directory": "/path/to/project",
    "command_history": ["command1", "command2"],
    "environment_variables": {
        "PATH": "...",
        "HOME": "..."
    },
    "process_info": {
        "shell": "/bin/zsh",
        "term": "xterm-256color",
        "user": "username",
        "hostname": "machine.local"
    }
}
```

## 🔒 Security Notes

- Environment variables are filtered to exclude sensitive data
- Database backups are kept locally only
- Command history is limited to last 50 commands
- No passwords or tokens are stored

## 🚀 Advanced Usage

### Custom Backup Script
Create your own backup triggers:
```bash
# In your project directories
echo "session-backup" >> ~/.zshrc  # Backup on shell start
```

### Integration with Git Hooks
```bash
# In .git/hooks/post-commit
#!/bin/bash
session-backup
```

### Restore to Different Directory
```bash
# Generate script and edit destination
session-script 1
# Edit the generated script to change directory
```

## 📈 Statistics

Check your session activity:
```bash
# Count backups per day
ls ~/.warp_session_backups/logs/session_*.json | wc -l

# Most active directories
sqlite3 "$HOME/Library/Application Support/dev.warp.Warp-Stable/warp.sqlite" \
  "SELECT working_directory, COUNT(*) as visits FROM sessions GROUP BY working_directory ORDER BY visits DESC LIMIT 10;"
```

## 📞 Support

If you encounter issues:
1. Check the logs in `~/.warp_session_backups/logs/`
2. Verify cron job is running: `crontab -l`
3. Test manual backup: `session-backup`
4. Check database: `session-list`

---

*Automated session management for enhanced productivity and workflow continuity.*
