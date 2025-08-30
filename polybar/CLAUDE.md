# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Polybar configuration repository for a Linux desktop environment using bspwm window manager. The configuration supports both single and multi-monitor setups with a custom Atom One Dark color theme.

## Architecture

### Main Configuration
- `config.ini`: Main Polybar configuration file defining bars, modules, and color scheme
  - Defines two bar profiles: `main` (primary monitor) and `secondary` (additional monitors)
  - Uses Atom One Dark color palette
  - Requires JetBrainsMono Nerd Font

### Scripts Directory
The `scripts/` directory contains bash scripts for various Polybar modules:
- `launch.sh`: Main launcher script that detects monitor configuration and spawns appropriate bars
- `cava.sh`: Audio visualizer integration
- `date-weather.sh`: Combined date and weather display
- `gpu.sh`: GPU usage monitoring
- `clipboard-menu.sh`: Clipboard manager integration
- `powermenu.sh`: Power menu for logout/shutdown options
- `monitor-setup.sh`: Monitor configuration helper
- `workspace-toggle.sh`: Workspace switching functionality

## Commands

### Launch Polybar
```bash
# Kill existing instances and launch new ones
killall -q polybar
~/.config/polybar/scripts/launch.sh
```

### Reload Configuration
```bash
# Reload without restarting (IPC must be enabled)
polybar-msg cmd restart
```

### Test Configuration
```bash
# Check config for errors
polybar --config=~/.config/polybar/config.ini main --check
```

## Key Module Dependencies

- **Window Manager**: bspwm (configured in bar settings)
- **Font**: JetBrainsMono Nerd Font (required for icons)
- **System Tools**: 
  - `xrandr` for monitor detection
  - `amixer` for volume control
  - `brightnessctl` for backlight control
  - `pavucontrol` for audio settings GUI

## Multi-Monitor Support

The configuration automatically detects connected monitors using `xrandr` and launches appropriate bars. The secondary monitor gets a simplified bar with fewer modules to avoid clutter.