# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Polybar configuration repository for a bspwm window manager setup on Linux. Polybar is a status bar for Linux that displays system information, workspaces, and custom modules.

## Architecture

### Core Components

- **config.ini**: Main Polybar configuration file defining bars, modules, colors, and layouts
  - Two bar configurations: `main` (primary monitor) and `secondary` (for multi-monitor setups)
  - Uses Atom One Dark color scheme
  - Modules include: workspaces, window title, date-weather, filesystem, memory, CPU, volume, battery, clipboard, and power menu

- **scripts/**: Shell scripts for custom modules and functionality
  - `launch.sh`: Main script to start Polybar, handles single/multi-monitor detection
  - `date-weather.sh`: Displays formatted date and time
  - `powermenu.sh`: Rofi-based power menu for system control (shutdown, reboot, suspend)
  - `cava.sh`: Audio visualizer integration using cava
  - `clipboard-menu.sh`: Clipboard history manager using greenclip and rofi
  - `gpu.sh`: GPU usage monitoring (referenced but not present)
  - `weather.sh`: Weather information (commented out in date-weather.sh)
  - `theme-toggle.sh`: Theme switching functionality (referenced)

### Module Configuration

Custom modules are defined as either:
- `custom/script`: For scripts that output text (e.g., cava, date-weather)
- `custom/text`: For clickable icons/text (e.g., powermenu, clipboard)

## Commands

### Launch Polybar
```bash
# Kill existing instances and launch
killall -q polybar
~/.config/polybar/scripts/launch.sh
```

### Reload Configuration
```bash
# Polybar automatically reloads when config.ini is modified
# Or manually:
polybar-msg cmd restart
```

### Test Individual Scripts
```bash
# Test date-weather module
~/.config/polybar/scripts/date-weather.sh

# Test power menu
~/.config/polybar/scripts/powermenu.sh
```

## Dependencies

This configuration requires:
- polybar
- bspwm (window manager)
- rofi (for menus)
- greenclip (clipboard manager)
- cava (audio visualizer)
- JetBrainsMono Nerd Font
- pavucontrol (volume control GUI)
- brightnessctl (backlight control)
- dunst (notifications)

## Key Configuration Points

- DPI is set to 125 for high-DPI displays
- Bar height: 28pt with radius of 6
- Font sizes are configured for JetBrainsMono Nerd Font (sizes 11-14)
- IPC is enabled for dynamic control via polybar-msg
- Secondary monitor bar has simplified modules (only workspaces and date)
- System tray is positioned on the right of the main bar