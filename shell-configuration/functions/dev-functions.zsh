# =====================================================================
# Development Functions - Advanced Shell Utilities
# Part of TiationSysAdmin Shell Configuration
# =====================================================================

# -----------------------------
# Git Enhancement Functions
# -----------------------------

# Smart git status with branch info and helpful suggestions
gstat() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    local branch=$(git branch --show-current)
    local remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
    local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
    
    echo "🔀 Branch: $branch"
    [[ -n "$remote_branch" ]] && echo "📡 Remote: $remote_branch"
    [[ "$ahead" -gt 0 ]] && echo "⬆️  Ahead: $ahead commits"
    [[ "$behind" -gt 0 ]] && echo "⬇️  Behind: $behind commits"
    echo ""
    
    git status --short --branch
    
    # Helpful suggestions
    local unstaged=$(git diff --name-only | wc -l | tr -d ' ')
    local staged=$(git diff --cached --name-only | wc -l | tr -d ' ')
    local untracked=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')
    
    echo ""
    echo "📊 Summary: $staged staged, $unstaged unstaged, $untracked untracked"
    
    # Suggestions
    if [[ "$unstaged" -gt 0 ]]; then
        echo "💡 Tip: Use 'ga .' to stage all changes or 'ga file' to stage specific files"
    fi
    if [[ "$staged" -gt 0 ]]; then
        echo "💡 Tip: Use 'gc -m \"message\"' to commit staged changes"
    fi
    if [[ "$ahead" -gt 0 ]]; then
        echo "💡 Tip: Use 'gp' to push commits to remote"
    fi
}

# Interactive git add with preview
gadd() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "❌ Not in a git repository"
        return 1
    fi
    
    if [[ $# -gt 0 ]]; then
        git add "$@"
        return
    fi
    
    # Interactive mode
    local files=($(git status --porcelain | awk '{print $2}'))
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "✅ No changes to add"
        return
    fi
    
    echo "📝 Files with changes:"
    local i=1
    for file in "${files[@]}"; do
        local status=$(git status --porcelain "$file" | cut -c1-2)
        printf "%2d) %s %s\n" $i "$status" "$file"
        ((i++))
    done
    
    echo ""
    echo "Options: [a]ll, [n]umbers (1,2,3), [q]uit"
    read -r "choice?Select files to add: "
    
    case "$choice" in
        a|A|all) git add . && echo "✅ Added all files" ;;
        q|Q|quit) echo "❌ Cancelled" ;;
        *) 
            for num in $(echo "$choice" | tr ',' ' '); do
                if [[ "$num" =~ ^[0-9]+$ ]] && [[ "$num" -le ${#files[@]} ]]; then
                    git add "${files[$num]}"
                    echo "✅ Added ${files[$num]}"
                fi
            done ;;
    esac
}

# Semantic git commit with conventional commit format
gcommit() {
    if [[ -z "$1" ]]; then
        echo "Usage: gcommit <type> <message> [scope]"
        echo ""
        echo "Types:"
        echo "  feat     - New feature"
        echo "  fix      - Bug fix" 
        echo "  docs     - Documentation changes"
        echo "  style    - Code style changes"
        echo "  refactor - Code refactoring"
        echo "  test     - Add/modify tests"
        echo "  chore    - Maintenance tasks"
        echo ""
        echo "Example: gcommit feat \"add user authentication\" auth"
        return 1
    fi
    
    local type="$1"
    local message="$2"
    local scope="${3:-}"
    
    # Validate type
    local valid_types=(feat fix docs style refactor test chore)
    if [[ ! " ${valid_types[@]} " =~ " ${type} " ]]; then
        echo "❌ Invalid type: $type"
        echo "Valid types: ${valid_types[*]}"
        return 1
    fi
    
    # Build commit message
    local commit_msg="$type"
    [[ -n "$scope" ]] && commit_msg="$commit_msg($scope)"
    commit_msg="$commit_msg: $message"
    
    git commit -m "$commit_msg"
}

# Git log with interactive filtering
glog() {
    local format='%C(red)%h%C(reset) - %C(yellow)%d%C(reset) %s %C(green)(%cr) %C(bold blue)<%an>%C(reset)'
    local limit="${1:-20}"
    
    if command -v fzf >/dev/null; then
        git log --oneline --color=always --format="$format" -n 100 | 
        fzf --ansi --preview 'echo {} | cut -d" " -f1 | xargs git show --color=always' \
            --header="Git Log (Enter to see details, Ctrl-C to exit)"
    else
        git log --oneline --graph --format="$format" -n "$limit"
    fi
}

# -----------------------------
# Development Environment Functions
# -----------------------------

# Smart project initializer with templates
proj-init() {
    local name="$1"
    local type="${2:-basic}"
    local template_dir="$HOME/.config/project-templates"
    
    if [[ -z "$name" ]]; then
        echo "Usage: proj-init <name> [type]"
        echo ""
        echo "Available types:"
        echo "  basic    - Basic project with README"
        echo "  node     - Node.js project with package.json"
        echo "  python   - Python project with virtual environment"
        echo "  go       - Go project with go.mod"
        echo "  react    - React project with TypeScript"
        echo "  next     - Next.js project"
        echo "  rust     - Rust project with Cargo.toml"
        return 1
    fi
    
    local project_dir="$WORKSPACE/10_projects/$name"
    
    if [[ -d "$project_dir" ]]; then
        echo "❌ Project '$name' already exists"
        return 1
    fi
    
    echo "🚀 Creating $type project: $name"
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Initialize git first
    git init
    
    case "$type" in
        "node"|"js")
            cat > package.json << EOF
{
  "name": "$name",
  "version": "1.0.0",
  "description": "",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "node --watch src/index.js",
    "test": "echo \\"Error: no test specified\\" && exit 1"
  },
  "keywords": [],
  "author": "$(git config user.name)",
  "license": "MIT"
}
EOF
            mkdir -p src tests
            echo "console.log('Hello, World!');" > src/index.js
            echo "node_modules/" > .gitignore
            ;;
            
        "python"|"py")
            python3 -m venv venv
            cat > requirements.txt << EOF
# Project dependencies
# Example: requests==2.28.1
EOF
            cat > main.py << EOF
#!/usr/bin/env python3
"""
$name - Main application module
"""

def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
EOF
            cat > .gitignore << EOF
venv/
__pycache__/
*.pyc
*.pyo
*.pyd
.env
.DS_Store
EOF
            chmod +x main.py
            ;;
            
        "react")
            if command -v npx >/dev/null; then
                npx create-react-app . --template typescript
            else
                echo "❌ npx not found. Installing basic React setup..."
                npm init -y
                npm install react react-dom @types/react @types/react-dom typescript
                mkdir -p src public
                echo "import React from 'react';\n\nfunction App() {\n  return <h1>Hello, World!</h1>;\n}\n\nexport default App;" > src/App.tsx
            fi
            ;;
            
        "go")
            go mod init "$name"
            cat > main.go << EOF
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
EOF
            ;;
            
        "rust")
            if command -v cargo >/dev/null; then
                cargo init --name "$name" .
            else
                echo "❌ Cargo not found. Creating basic Rust project..."
                mkdir src
                cat > Cargo.toml << EOF
[package]
name = "$name"
version = "0.1.0"
edition = "2021"

[dependencies]
EOF
                cat > src/main.rs << EOF
fn main() {
    println!("Hello, World!");
}
EOF
            fi
            ;;
            
        *)
            cat > README.md << EOF
# $name

Project description here.

## Getting Started

\`\`\`bash
# Add your setup instructions here
\`\`\`

## Usage

\`\`\`bash
# Add usage examples here
\`\`\`

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
EOF
            ;;
    esac
    
    # Add common files
    if [[ ! -f ".gitignore" ]]; then
        cat > .gitignore << EOF
.DS_Store
*.log
.env
.env.local
EOF
    fi
    
    git add .
    git commit -m "feat: initial project setup

- Created $type project structure
- Added basic configuration files
- Ready for development"
    
    echo "✅ Project '$name' created successfully!"
    echo "📂 Location: $project_dir"
    [[ -f "package.json" ]] && echo "📦 Run 'npm install' to install dependencies"
    [[ -f "requirements.txt" ]] && echo "🐍 Run 'source venv/bin/activate && pip install -r requirements.txt' to set up Python environment"
    [[ -f "Cargo.toml" ]] && echo "🦀 Run 'cargo build' to build the Rust project"
}

# Quick development server launcher
dev-serve() {
    local port="${1:-3000}"
    
    # Detect project type and start appropriate dev server
    if [[ -f "package.json" ]]; then
        if grep -q "next" package.json; then
            echo "🚀 Starting Next.js dev server..."
            npm run dev
        elif grep -q "react-scripts" package.json; then
            echo "⚛️  Starting React dev server..."
            npm start
        elif grep -q "\"dev\"" package.json; then
            echo "📦 Starting npm dev server..."
            npm run dev
        else
            echo "📦 Starting Node.js app..."
            npm start
        fi
    elif [[ -f "Cargo.toml" ]]; then
        echo "🦀 Running Rust project..."
        cargo run
    elif [[ -f "main.py" ]] || [[ -f "app.py" ]]; then
        echo "🐍 Starting Python application..."
        if [[ -d "venv" ]]; then
            source venv/bin/activate
        fi
        python3 main.py 2>/dev/null || python3 app.py
    elif [[ -f "main.go" ]]; then
        echo "🐹 Running Go application..."
        go run main.go
    else
        echo "🌐 Starting HTTP server on port $port..."
        python3 -m http.server "$port"
    fi
}

# -----------------------------
# Productivity Functions
# -----------------------------

# Smart file backup with timestamp
backup() {
    [[ -z "$1" ]] && { echo "Usage: backup <file_or_directory>"; return 1; }
    
    local source="$1"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_name="${source%/}_backup_$timestamp"
    
    if [[ -d "$source" ]]; then
        tar -czf "$backup_name.tar.gz" "$source"
        echo "📁 Directory backed up: $backup_name.tar.gz"
    else
        cp "$source" "$backup_name"
        echo "📄 File backed up: $backup_name"
    fi
}

# Enhanced process management
pskill() {
    [[ -z "$1" ]] && { echo "Usage: pskill <pattern>"; return 1; }
    
    local pattern="$1"
    local pids=($(pgrep -f "$pattern"))
    
    if [[ ${#pids[@]} -eq 0 ]]; then
        echo "❌ No processes found matching: $pattern"
        return 1
    fi
    
    echo "🔍 Found processes:"
    ps -p "${pids[@]}" -o pid,ppid,pcpu,pmem,time,comm
    
    echo ""
    read -r "confirm?Kill these processes? [y/N]: "
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        kill "${pids[@]}"
        echo "💀 Processes killed"
    else
        echo "❌ Cancelled"
    fi
}

# System resource monitor
sysmon() {
    local interval="${1:-2}"
    
    echo "🖥️  System Monitor (press Ctrl+C to exit)"
    echo "Refreshing every $interval seconds..."
    echo ""
    
    while true; do
        clear
        echo "🖥️  System Monitor - $(date)"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # CPU and Memory
        echo "💾 Memory Usage:"
        vm_stat | awk '
        BEGIN { total=0; used=0; }
        /Pages free/ { free=$3 }
        /Pages active/ { active=$3; used+=active }
        /Pages inactive/ { inactive=$3; used+=inactive }
        /Pages speculative/ { spec=$3; used+=spec }
        /Pages wired down/ { wired=$4; used+=wired }
        END { 
            total=free+used
            if(total>0) printf "Used: %.1f%% (%.2f GB / %.2f GB)\n", (used/total)*100, used*4096/(1024^3), total*4096/(1024^3)
        }'
        
        echo ""
        echo "🔥 Top Processes by CPU:"
        ps aux --sort=-%cpu | head -6 | awk 'NR==1{print $0} NR>1{printf "%-8s %5s%% %5s%% %s\n", $2, $3, $4, $11}'
        
        echo ""
        echo "💾 Top Processes by Memory:"
        ps aux --sort=-%mem | head -6 | awk 'NR==1{print $0} NR>1{printf "%-8s %5s%% %5s%% %s\n", $2, $3, $4, $11}'
        
        echo ""
        echo "💿 Disk Usage:"
        df -h | grep -E '^/dev/' | awk '{printf "%-20s %8s %8s %8s %5s\n", $1, $2, $3, $4, $5}'
        
        sleep "$interval"
    done
}

# Network connection tester
nettest() {
    local hosts=("google.com" "github.com" "cloudflare.com")
    
    echo "🌐 Network Connectivity Test"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    for host in "${hosts[@]}"; do
        if ping -c 1 -W 2000 "$host" >/dev/null 2>&1; then
            local latency=$(ping -c 1 "$host" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
            echo "✅ $host - ${latency:-N/A}"
        else
            echo "❌ $host - Unreachable"
        fi
    done
    
    echo ""
    echo "📡 External IP: $(curl -s ifconfig.me)"
    echo "🏠 Local IP: $(ipconfig getifaddr en0 2>/dev/null || echo "Not connected")"
    echo "🔗 DNS: $(scutil --dns | grep nameserver | head -1 | awk '{print $3}')"
}

# Quick note taking
note() {
    local notes_dir="$HOME/.notes"
    local note_file="$notes_dir/$(date +%Y-%m).md"
    
    mkdir -p "$notes_dir"
    
    if [[ -z "$1" ]]; then
        # Open notes file in editor
        $EDITOR "$note_file"
    else
        # Quick note
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "## $timestamp" >> "$note_file"
        echo "$*" >> "$note_file"
        echo "" >> "$note_file"
        echo "📝 Note added to $(basename "$note_file")"
    fi
}

# Search notes
note-search() {
    local notes_dir="$HOME/.notes"
    local pattern="$1"
    
    if [[ -z "$pattern" ]]; then
        echo "Usage: note-search <pattern>"
        echo "Available notes:"
        ls -la "$notes_dir"/*.md 2>/dev/null | awk '{print $9}' | xargs basename -s .md
        return 1
    fi
    
    grep -n -i --color=always "$pattern" "$notes_dir"/*.md 2>/dev/null | head -20
}

# -----------------------------
# Utility Functions
# -----------------------------

# Extract any archive
extract() {
    [[ -z "$1" ]] && { echo "Usage: extract <archive>"; return 1; }
    [[ ! -f "$1" ]] && { echo "❌ File not found: $1"; return 1; }
    
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "❌ Unsupported archive format: $1" ;;
    esac
    
    [[ $? -eq 0 ]] && echo "✅ Extracted: $1"
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Show directory tree with size info
dtree() {
    local depth="${1:-2}"
    local target="${2:-.}"
    
    if command -v tree >/dev/null; then
        tree -L "$depth" -h "$target"
    elif command -v eza >/dev/null; then
        eza --tree --level="$depth" --long "$target"
    else
        find "$target" -maxdepth "$depth" -type d | sort
    fi
}

# Calculate directory sizes
dsize() {
    local target="${1:-.}"
    du -sh "$target"/* 2>/dev/null | sort -hr | head -20
}

echo "🔧 Development functions loaded!"
echo "Available commands: gstat, gadd, gcommit, glog, proj-init, dev-serve, backup, pskill, sysmon, nettest, note, extract, mkcd, dtree, dsize"
