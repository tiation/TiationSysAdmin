# Warp Terminal Themes

Custom themes for [Warp Terminal](https://www.warp.dev/) designed for developer productivity and eye comfort.

## Available Themes

### Tiation Default Dark
- **File**: `tiation-default-dark.yaml`
- **Description**: Low-glare dark theme with warm accents and high contrast
- **Best for**: Extended coding sessions, night work
- **Key features**: Near-black background (#0B0F14), warm cursor (#FFD166), vibrant syntax colors

### Tiation Default Light  
- **File**: `tiation-default-light.yaml`
- **Description**: Soft light theme with clean contrast and reduced eye strain
- **Best for**: Daytime work, documentation, bright environments
- **Key features**: Soft white background (#F8FAFB), warm cursor (#E89611), balanced colors

## Installation

### Quick Install
```bash
# Run the installer script
bash install-themes.sh
```

### Manual Install
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

## Features

- **ANSI Color Support**: Full 16-color palette with bright variants
- **UI Accents**: Primary, warning, success, and danger colors
- **High Contrast**: Meets accessibility standards
- **Eye Comfort**: Designed to reduce strain during long sessions
- **Syntax Highlighting**: Optimized for code readability

## Compatibility

- **Warp Version**: 0.2024.01.23.08.03.stable+
- **Format**: YAML (Warp theme format v1)
- **Platform**: macOS, Linux

## Troubleshooting

**Theme not appearing?**
- Ensure files are in `~/.warp/themes/`
- Restart Warp Terminal
- Check YAML syntax is valid

**Colors not displaying correctly?**
- Verify terminal supports true color (24-bit)
- Check color profile settings in System Preferences

## Contributing

Found an issue or want to suggest improvements? Please open an issue or PR in the main TiationSysAdmin repository.
