# TiationSysAdmin

A collection of system administration tools, configurations, and automation scripts for enhanced productivity and system management.

## 📁 Repository Structure

```
TiationSysAdmin/
├── warp-terminal/          # Warp Terminal configurations and tools
│   └── session-backup/     # Automatic session backup and restore system
├── warp-themes/            # Custom Warp Terminal themes
│   ├── tiation-default-dark.yaml   # Professional dark theme
│   ├── tiation-default-light.yaml  # Clean light theme
│   ├── install-themes.sh   # Theme installer script
│   └── README.md           # Theme documentation
├── shell-configuration/    # Enhanced shell configuration system
│   ├── configs/           # Shell configuration files (.zshrc)
│   ├── functions/         # Advanced development functions
│   └── install.sh         # Shell configuration installer
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

### Custom Warp Terminal Themes

**Location**: `warp-themes/`

Custom themes designed for developer productivity and eye comfort, with both dark and light variants that sync with your OS theme.

**Features**:
- ✅ Professional dark theme with low-glare background
- ✅ Clean light theme with reduced eye strain
- ✅ High contrast for accessibility
- ✅ Optimized syntax highlighting colors
- ✅ OS theme sync support (auto-switch light/dark)
- ✅ Easy one-command installation

**Quick Install**:
```bash
cd warp-themes
bash install-themes.sh
```

**Quick Setup** (after installation):
1. Open Warp → Settings → Appearance
2. Click "Custom Themes" box
3. Select "Tiation Default Dark" or "Tiation Default Light"
4. Enable "Sync with OS" for automatic theme switching

[→ Full Documentation](warp-themes/README.md)

### Enhanced Shell Configuration System

**Location**: `shell-configuration/`

A comprehensive, performance-optimized shell configuration system with advanced developer tools, productivity functions, and beautiful prompts.

**Features**:
- ✅ Performance-optimized startup with lazy loading
- ✅ Enhanced Git workflows with semantic commits
- ✅ Project scaffolding for multiple languages
- ✅ System monitoring and network diagnostics
- ✅ Beautiful Spaceship prompt with smart context
- ✅ 50+ productivity aliases and functions
- ✅ Smart completions and tab enhancements

**Quick Install**:
```bash
cd shell-configuration
./install.sh
```

**Quick Commands** (after installation):
```bash
gstat     # Enhanced git status with tips
proj-init myapp node  # Create new Node.js project
sysmon    # Real-time system monitoring
nettest   # Network connectivity diagnostics
aliases-help  # Show all available commands
```

[→ Full Documentation](shell-configuration/README.md)

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

Completed:
- [x] **Warp terminal session backup system** - Automatic session management
- [x] **Enhanced shell configuration** - Performance-optimized shell with developer tools
- [x] **Custom Warp themes** - Professional dark/light themes with OS sync

Future additions may include:

- [ ] Git workflow automation scripts
- [ ] Development environment setup scripts
- [ ] Backup and sync tools
- [ ] macOS system configuration scripts
- [ ] Docker/containerization utilities
- [ ] Monitoring and alerting scripts
- [ ] VS Code configuration synchronization
- [ ] Homebrew package management automation

---

*Personal system administration toolkit by Tia Astor*
