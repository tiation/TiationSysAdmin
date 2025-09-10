# Warp Terminal Themes

Custom themes for [Warp Terminal](https://www.warp.dev/) designed for developer productivity and eye comfort.

## Available Themes

### 🌙 Tiation Default Dark
- **File**: `tiation-default-dark.yaml`
- **Description**: Professional dark theme optimized for developer productivity
- **Best for**: Extended coding sessions, general development work
- **Key features**: GitHub-inspired dark background (#0D1117), high-contrast text, syntax-optimized colors
- **Contrast ratio**: WCAG AA compliant (4.5:1+)

### ☀️ Tiation Default Light
- **File**: `tiation-default-light.yaml`
- **Description**: Clean light theme optimized for bright environments
- **Best for**: Daytime coding, documentation, well-lit spaces
- **Key features**: Pure white background (#FFFFFF), GitHub-style colors, excellent readability
- **Contrast ratio**: WCAG AA compliant (4.5:1+)

### 🔆 Tiation High Contrast Dark
- **File**: `tiation-high-contrast-dark.yaml`
- **Description**: Ultra-high contrast dark theme for accessibility
- **Best for**: Visual impairments, maximum readability, accessibility compliance
- **Key features**: Pure black background (#000000), maximum contrast colors, WCAG AAA compliant
- **Accessibility**: Optimized for screen readers and visual impairments

### ⚡ Tiation High Contrast Light
- **File**: `tiation-high-contrast-light.yaml`
- **Description**: Ultra-high contrast light theme for accessibility
- **Best for**: Visual impairments in bright environments, accessibility compliance
- **Key features**: Pure white background, maximum contrast text, WCAG AAA compliant
- **Accessibility**: Optimized for screen readers and visual impairments

### 🌌 Tiation Dimmed Dark
- **File**: `tiation-dimmed-dark.yaml`
- **Description**: Ultra-low intensity dark theme for late-night coding
- **Best for**: Night coding, reducing eye strain, minimal blue light exposure
- **Key features**: Very dark background (#0A0C10), muted colors, gentle on eyes
- **Health**: Designed to reduce eye fatigue and support better sleep patterns

## Installation

### 🚀 Quick Install (Recommended)
```bash
# Install all themes
bash install-themes.sh

# Interactive installation with options
bash install-themes.sh --interactive

# Install basic themes only (default dark + light)
bash install-themes.sh --basic

# Install accessibility themes only
bash install-themes.sh --accessibility
```

### 📋 List Available Themes
```bash
# See all available themes
bash install-themes.sh --list
```

### 🔍 Preview and Validate
```bash
# Preview themes with sample code
bash preview-themes.sh

# Validate theme files
bash preview-themes.sh --validate

# Preview specific theme
bash preview-themes.sh tiation-default-dark.yaml
```

### 🛠️ Manual Install
```bash
# Copy themes to Warp's themes directory
mkdir -p ~/.warp/themes
cp *.yaml ~/.warp/themes/
```

### Apply Theme
1. Open Warp Terminal
2. Go to `Settings > Appearance` (or `Cmd + ,`)
3. Click the **Custom Themes** box
4. Select "Tiation Default Dark" or "Tiation Default Light"
5. Press the checkmark to save

### OS Theme Sync (Recommended)
1. In `Settings > Appearance`, toggle **"Sync with OS"**
2. Set:
   - **Light mode**: Tiation Default Light
   - **Dark mode**: Tiation Default Dark

## Color Palette

### Dark Theme
- **Background**: `#0B0F14` (near-black)
- **Foreground**: `#E6E6E6` (high contrast)
- **Cursor**: `#FFD166` (warm yellow)
- **Selection**: `#1A2230` (subtle blue)

### Light Theme  
- **Background**: `#F8FAFB` (soft white)
- **Foreground**: `#1F2937` (clean dark)
- **Cursor**: `#E89611` (warm orange)
- **Selection**: `#E0F2FE` (light blue)

## ✨ Features

### Core Features
- **🎨 Full Color Palette**: Complete 16-color ANSI support with bright variants
- **📱 Warp Integration**: Extended UI elements (borders, hover states, focus indicators)
- **♿ Accessibility**: WCAG AA/AAA compliance with high contrast variants
- **👁️ Eye Comfort**: Scientifically designed to reduce strain and fatigue
- **📝 Syntax Optimization**: Language-specific color optimization for 20+ languages

### Developer Experience
- **🔄 Git Integration**: Optimized diff colors for additions, deletions, modifications
- **📊 Error Handling**: High-visibility error and warning colors
- **🔍 Code Readability**: Distinct colors for keywords, strings, comments, functions
- **🎯 Terminal UI**: Specialized colors for borders, selections, and interactive elements

### Health & Comfort
- **🌙 Blue Light Reduction**: Dimmed variants minimize blue light exposure
- **⏰ Circadian Friendly**: Night-optimized colors support natural sleep cycles
- **⚙️ Customizable**: Multiple variants for different use cases and preferences

## 🎨 Theme Selection Guide

### Choose Based on Your Needs

| Use Case | Recommended Theme | Why |
|----------|------------------|-----|
| **General Development** | Default Dark/Light | Balanced colors, proven readability |
| **Long Coding Sessions** | Default Dark or Dimmed Dark | Reduced eye strain, comfortable contrast |
| **Bright Environments** | Default Light or High Contrast Light | Excellent readability in sunlight |
| **Accessibility Needs** | High Contrast Dark/Light | WCAG AAA compliance, maximum contrast |
| **Late Night Coding** | Dimmed Dark | Minimal blue light, circadian friendly |
| **Pair Programming** | Default themes | Familiar colors, broad appeal |

### Color Personality Guide
- **Professional**: Default themes - clean, GitHub-inspired
- **Accessibility-First**: High Contrast themes - maximum readability
- **Health-Conscious**: Dimmed Dark - eye strain reduction
- **Versatile**: OS Theme Sync - automatic switching

## 🖥️ Compatibility

- **Warp Version**: 0.2024.01.23.08.03.stable+ (latest recommended)
- **Format**: YAML (Warp theme format v1+)
- **Platform**: macOS, Linux (Windows support coming)
- **Terminal Support**: True color (24-bit) required

## 🔧 Troubleshooting

### Installation Issues

**Theme not appearing in Warp?**
```bash
# Check installation
ls -la ~/.warp/themes/tiation*.yaml

# Validate themes
./preview-themes.sh --validate

# Restart Warp completely
killall Warp && open -a Warp
```

**Installation script fails?**
- Ensure Warp is installed: `ls /Applications/Warp.app`
- Check permissions: `ls -la ~/.warp/`
- Manual install: `mkdir -p ~/.warp/themes && cp *.yaml ~/.warp/themes/`

### Display Issues

**Colors look wrong or washed out?**
- Verify true color support: `echo $COLORTERM` (should show "truecolor")
- Check macOS color profile: System Preferences → Displays → Color
- Reset terminal: Restart Warp completely

**Themes appear but don't apply?**
- Clear Warp cache: `rm -rf ~/Library/Caches/dev.warp.Warp-Stable`
- Check theme format: `./preview-themes.sh --validate`
- Try different theme first, then switch back

### Performance Issues

**Warp slower after installing themes?**
- Themes don't affect performance - check other factors
- Reset to default theme temporarily to test
- Clear application cache and restart

### Getting Help

1. **Check validation**: Run `./preview-themes.sh --validate`
2. **Test in clean environment**: Create new Warp session
3. **Check Warp version**: Help → About Warp (need v0.2024+)
4. **Report issues**: Include OS version, Warp version, theme name

## Contributing

Found an issue or want to suggest improvements? Please open an issue or PR in the main TiationSysAdmin repository.
