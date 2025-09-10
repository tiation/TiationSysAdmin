# TiationSysAdmin

A collection of system administration tools, configurations, and automation scripts for enhanced productivity and system management.

## 📁 Repository Structure

```
TiationSysAdmin/
├── warp-terminal/          # Warp Terminal configurations and tools
│   └── session-backup/     # Automatic session backup and restore system
└── README.md              # This file
```

## 🚀 Quick Start

Each tool/configuration has its own directory with specific installation instructions. Navigate to the relevant folder for detailed setup guides.

## 🛠️ Available Tools

### Warp Terminal Session Backup System

**Location**: `warp-terminal/session-backup/`

A comprehensive session management system that automatically backs up your Warp terminal sessions and allows you to restore them later.

**Features**:
- ✅ Automatic session backups every 5 minutes via cron
- ✅ SQLite database storage with JSON backup files
- ✅ Command history and environment variable capture
- ✅ Easy-to-use restore functionality
- ✅ Shell aliases for quick access
- ✅ Automatic cleanup of old backups

**Quick Install**:
```bash
cd warp-terminal/session-backup
./install.sh
```

**Quick Commands** (after installation):
```bash
sl    # List sessions
ss 1  # Show session details
sr 1  # Restore session
sb    # Backup current session
```

[→ Full Documentation](warp-terminal/session-backup/docs/README.md)

---

## 📋 Installation Guidelines

Each tool follows these conventions:

1. **Self-contained**: Each tool lives in its own directory
2. **Automated setup**: Most tools include an `install.sh` script
3. **Documentation**: Each tool has comprehensive README documentation
4. **Examples**: Configuration examples and usage patterns provided
5. **Uninstall support**: Clean removal when no longer needed

## 🔧 General Requirements

- **macOS** (primary target platform)
- **Bash/Zsh** shell environment
- **Git** for cloning the repository
- Tool-specific requirements listed in individual READMEs

## 📚 Documentation

- Each tool has its own README with installation and usage instructions
- Example configurations provided where applicable
- Troubleshooting sections for common issues

## 🤝 Contributing

This is a personal system administration repository, but contributions and suggestions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes with proper documentation
4. Submit a pull request

## 📝 License

This repository contains personal system administration tools and configurations. Use at your own discretion and adapt to your own needs.

---

## 🎯 Roadmap

Future additions may include:

- [ ] Git workflow automation scripts
- [ ] Development environment setup scripts
- [ ] Backup and sync tools
- [ ] macOS system configuration scripts
- [ ] Docker/containerization utilities
- [ ] Monitoring and alerting scripts

---

*Personal system administration toolkit by Tia Astor*
