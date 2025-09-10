# Enhanced Shell Configuration System

A comprehensive, performance-optimized shell configuration system with advanced developer tools, productivity functions, and beautiful prompts.

## 🚀 Quick Install

```bash
# Clone the repository
git clone https://github.com/tiation/TiationSysAdmin.git
cd TiationSysAdmin/shell-configuration

# Run the installer
./install.sh
```

## ✨ Features

### 🎯 **Performance Optimized**
- **Fast startup** with lazy loading and async operations
- **Smart caching** for completions and expensive operations  
- **Efficient PATH management** with duplicate removal
- **Background loading** of heavy components

### 🔧 **Developer Tools**
- **Enhanced Git workflows** with smart status, interactive adds, and semantic commits
- **Project scaffolding** for Node.js, Python, Go, React, Rust projects
- **Docker & Kubernetes** shortcuts with better formatting
- **Development server** auto-detection and launching

### 📊 **System Utilities**
- **System monitoring** with real-time stats (CPU, memory, disk)
- **Network diagnostics** and connectivity testing
- **Process management** with interactive killing
- **File operations** with smart backups and archives

### 🎨 **Beautiful Interface**
- **Spaceship prompt** with git status, battery, and time
- **Colorized output** for all commands and functions
- **Welcome messages** with daily tips and system info
- **Responsive design** that adapts to terminal width

### 📝 **Productivity Features**
- **Note taking** system with search functionality
- **Quick navigation** to workspace directories  
- **Smart aliases** for common operations
- **Tab completions** for enhanced workflow

## 🗂️ Directory Structure

```
shell-configuration/
├── install.sh                 # Main installer script
├── configs/
│   └── .zshrc                 # Enhanced zshrc configuration
├── functions/
│   └── dev-functions.zsh      # Development utility functions
├── themes/                    # Shell themes (future expansion)
├── completions/               # Custom completions (future expansion)
├── examples/                  # Example configurations
└── README.md                  # This documentation
```

## 🛠️ Installation Options

### Automatic Installation (Recommended)

```bash
./install.sh
```

This will:
- ✅ Backup your existing shell configuration
- ✅ Install Oh My Zsh and useful plugins
- ✅ Set up Spaceship prompt
- ✅ Install development functions and aliases
- ✅ Configure performance optimizations
- ✅ Test the installation

### Manual Installation

```bash
# Backup existing configuration
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d)

# Copy enhanced configuration
cp configs/.zshrc ~/.zshrc

# Create config directory
mkdir -p ~/.config/tiation-shell/functions

# Copy functions
cp functions/* ~/.config/tiation-shell/functions/

# Restart shell
exec zsh -l
```

### Update Existing Configuration

If you want to keep your current zshrc and just add enhancements:

```bash
./install.sh  # Choose to update existing config
```

## 🎮 Available Commands

### Git Enhancement Commands
| Command | Description | Example |
|---------|-------------|---------|
| `gstat` | Enhanced git status with branch info and tips | `gstat` |
| `gadd` | Interactive git add with file selection | `gadd` or `gadd file.txt` |
| `gcommit` | Semantic commits with conventional format | `gcommit feat "add login" auth` |
| `glog` | Interactive git log with fzf preview | `glog` |

### Development Tools
| Command | Description | Example |
|---------|-------------|---------|
| `proj-init` | Create new project with scaffolding | `proj-init myapp node` |
| `dev-serve` | Smart development server launcher | `dev-serve` or `dev-serve 8080` |
| `envinfo` | Display system and development environment info | `envinfo` |

### System Utilities
| Command | Description | Example |
|---------|-------------|---------|
| `sysmon` | Real-time system monitor | `sysmon` or `sysmon 5` |
| `nettest` | Network connectivity diagnostics | `nettest` |
| `pskill` | Interactive process killer | `pskill node` |
| `backup` | Smart file/directory backup | `backup myfile.txt` |

### File Operations
| Command | Description | Example |
|---------|-------------|---------|
| `extract` | Universal archive extractor | `extract file.tar.gz` |
| `mkcd` | Create directory and cd into it | `mkcd new-project` |
| `dtree` | Directory tree with size info | `dtree 3` |
| `dsize` | Directory size analysis | `dsize /path/to/dir` |

### Productivity Tools
| Command | Description | Example |
|---------|-------------|---------|
| `note` | Quick note taking | `note "remember this"` |
| `note-search` | Search through notes | `note-search "keyword"` |
| `weather` | Get weather forecast | `weather` or `weather London` |
| `serve` | Start HTTP server in current directory | `serve` or `serve 8000` |

### Navigation & Aliases
| Alias | Description | Equivalent |
|-------|-------------|------------|
| `ws` | Go to workspace | `cd ~/workspace` |
| `proj` | Go to projects directory | `cd ~/workspace/10_projects` |
| `..`, `...`, `....` | Navigate up directories | `cd ..`, `cd ../..`, etc. |
| `ll`, `la` | Enhanced ls with icons (eza) | `eza -la --icons --git` |
| `g` | Git shortcut | `git` |
| `k` | Kubectl shortcut | `kubectl` |
| `dps` | Formatted docker ps | `docker ps --format table` |

## 🔧 Configuration

### Environment Variables

The shell configuration sets up these key environment variables:

```bash
WORKSPACE="$HOME/workspace"           # Main workspace directory
JAVA_HOME="/opt/homebrew/opt/openjdk@17"
ANDROID_HOME="$HOME/Library/Android/sdk"
EDITOR="code"                         # Default editor
PAGER="less"                         # Default pager
```

### Customization

#### Add Your Own Functions

Create files in `~/.config/tiation-shell/functions/` with `.zsh` extension:

```bash
# ~/.config/tiation-shell/functions/my-functions.zsh
my_custom_function() {
    echo "This is my custom function"
}
```

#### Override Defaults

You can override any configuration by adding to your `~/.zshrc` after the Tiation sections:

```bash
# Your custom overrides
export WORKSPACE="$HOME/my-workspace"
alias my_alias="my command"
```

#### Disable Features

Set these environment variables to disable specific features:

```bash
export DISABLE_WELCOME_MESSAGE=1     # Disable welcome message
export DISABLE_AUTO_LS=1             # Disable auto-ls after cd
export DISABLE_GIT_INFO=1            # Disable git info in cd
```

## 📚 Project Templates

The `proj-init` command supports these project types:

### Node.js (`node` or `js`)
- Creates `package.json` with scripts
- Sets up `src/` and `tests/` directories
- Includes `.gitignore` for Node.js
- Initial `src/index.js` file

### Python (`python` or `py`)
- Creates virtual environment
- Sets up `requirements.txt`
- Creates executable `main.py`
- Includes comprehensive `.gitignore`

### Go (`go`)
- Initializes Go module
- Creates `main.go` with Hello World
- Sets up proper project structure

### React (`react`)
- Uses Create React App with TypeScript
- Falls back to manual setup if npx unavailable
- Creates basic React component structure

### Rust (`rust`)
- Uses Cargo to initialize project
- Creates `Cargo.toml` and `src/main.rs`
- Sets up Rust best practices

### Basic (`basic` or default)
- Creates comprehensive `README.md`
- Includes contribution guidelines
- Sets up basic `.gitignore`

## 🎨 Prompt Configuration

The enhanced shell uses Spaceship prompt with these features:

- **Time display** in the right prompt
- **Battery indicator** when below 20%
- **Git branch and status** with colors
- **Exit code display** for failed commands
- **Docker, AWS, Kubernetes context** when relevant
- **Node.js, Python version** detection

### Customize Prompt

```bash
# Add to ~/.zshrc after Tiation sections
export SPACESHIP_TIME_SHOW=false           # Hide time
export SPACESHIP_BATTERY_THRESHOLD=10      # Show battery at 10%
export SPACESHIP_GIT_STATUS_SHOW=false     # Hide git status
```

## 🚀 Performance Tips

### Startup Time Optimization

The configuration is optimized for fast startup:

1. **Lazy loading** of expensive tools (nvm, conda)
2. **Async loading** of heavy components
3. **Cached completions** rebuilt once per day
4. **Background processing** for non-essential tasks

### Measure Startup Time

Uncomment the zprof lines in your `.zshrc` to measure:

```bash
# At the top of ~/.zshrc
zmodload zsh/zprof

# At the bottom of ~/.zshrc  
zprof
```

### Further Optimization

- Use SSD storage for best performance
- Keep plugin count minimal
- Regularly clean old history files
- Update tools and dependencies regularly

## 🛠️ Troubleshooting

### Common Issues

#### Slow Startup
```bash
# Check what's taking time
zmodload zsh/zprof
source ~/.zshrc
zprof
```

#### Missing Commands
```bash
# Reload configuration
source ~/.zshrc

# Check if functions loaded
command -v gstat
```

#### Plugin Issues
```bash
# Reinstall Oh My Zsh plugins
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-*
./install.sh  # Reinstall
```

#### Prompt Issues
```bash
# Reinstall Spaceship
brew uninstall spaceship
brew install spaceship
```

### Getting Help

1. **Check installation**: `./install.sh test`
2. **View available commands**: `aliases-help`
3. **Check environment**: `envinfo`
4. **View logs**: Check `~/.config/tiation-shell/`

## 🔄 Updates and Maintenance

### Update Configuration

```bash
cd TiationSysAdmin/shell-configuration
git pull origin main
./install.sh  # Reinstall with updates
```

### Backup and Restore

Backups are automatically created during installation in:
`~/.config/tiation-shell/backups/`

To restore:
```bash
cp ~/.config/tiation-shell/backups/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
```

### Uninstall

```bash
./install.sh uninstall
```

This will:
- Remove Tiation enhancements from shell config
- Clean up configuration directories  
- Restore your shell to previous state

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add your enhancements
4. Test thoroughly
5. Submit a pull request

### Adding New Functions

Functions should follow these patterns:

```bash
# Enhanced function with help and error checking
my_function() {
    # Help text
    if [[ -z "$1" || "$1" == "--help" ]]; then
        echo "Usage: my_function <arg>"
        echo "Description: What this function does"
        return 1
    fi
    
    # Error checking
    [[ ! -f "$1" ]] && { echo "❌ File not found: $1"; return 1; }
    
    # Main functionality
    echo "✅ Success message"
}
```

## 📄 License

This shell configuration is part of the TiationSysAdmin toolkit. Use and modify according to your needs.

---

**Enhanced Shell Configuration** - Part of the TiationSysAdmin System Administration Toolkit
