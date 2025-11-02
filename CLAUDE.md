# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository for a Linux system configuration. It contains configurations for various window managers, terminal applications, and desktop environments, with NixOS flakes for declarative system management.

## Architecture

### Core Components

1. **Window Manager Configurations**
   - `bspwm/` - Binary Space Partitioning Window Manager (deleted in current changes)
   - `hypr/` - Hyprland compositor configuration (Wayland)
     - `hyprland.conf`: Main configuration
     - `keybinds.conf`: Keyboard shortcuts
     - `rules.conf`: Window rules
     - `colors.conf`: Color scheme
     - `execs.conf`: Autostart applications

2. **NixOS Configuration** (`flakes/hp-laptop/`)
   - Modular NixOS configuration using flakes
   - `configuration.nix`: Main entry point importing all modules
   - `packages/`: Package sets organized by category (development, desktop, system, theming, utilities)
   - Hardware, networking, audio, and appearance modules

3. **Terminal & Shell**
   - `fish/`: Fish shell configuration with custom functions and aliases
   - `kitty/`: GPU-accelerated terminal emulator
   - `alacritty/`: Another terminal emulator option
   - `ghostty/`: Terminal configuration

4. **Status Bar & Desktop**
   - `polybar/`: Status bar configuration with custom scripts
     - Custom modules for weather, power menu, clipboard, GPU monitoring
     - Launch scripts for single/multi-monitor setups
   - `rofi/`: Application launcher and menu system
   - `dunst/`: Notification daemon

5. **Development Tools**
   - `nvim/`: Neovim configuration
   - `git/`: Git configuration
   - `zellij/`: Terminal multiplexer layouts

6. **Application Configs**
   - `btop/`: System monitor
   - `yazi/`: Terminal file manager
   - `zathura/`: PDF viewer
   - `flameshot/`: Screenshot tool
   - Various other application configurations

## Common Commands

### NixOS System Management
```bash
# Rebuild NixOS configuration
sudo nixos-rebuild switch --flake ~/.config/flakes/hp-laptop#default

# Update flake inputs
nix flake update ~/.config/flakes/hp-laptop

# Clean old generations
sudo nix-collect-garbage -d
```

### Window Manager Operations
```bash
# Restart Hyprland (from within Hyprland)
hyprctl reload

# Launch Polybar
~/.config/polybar/scripts/launch.sh

# Test Polybar scripts
~/.config/polybar/scripts/date-weather.sh
~/.config/polybar/scripts/powermenu.sh
```

### Development Workflow
```bash
# Open editor (aliased to nvim)
vim [file]

# Terminal multiplexer with custom layouts
zel  # Professional layout
xel  # Codex layout

# File manager with cd on quit
y
```

## Key Configuration Patterns

1. **Modular Configuration**: Most configurations are split into logical modules that can be imported/sourced
2. **Color Theming**: Consistent use of Atom One Dark theme across applications
3. **Font**: JetBrainsMono Nerd Font is the standard throughout
4. **Scripts**: Shell scripts in various `scripts/` directories handle automation and custom functionality
5. **Fish Shell**: Custom functions and aliases defined in `config.fish` for common operations

## Dependencies & Requirements

- **System**: NixOS with flakes enabled
- **Display**: Wayland (Hyprland) or X11 (bspwm)
- **Fonts**: JetBrainsMono Nerd Font
- **Shell**: Fish shell with starship prompt
- **Key Tools**: rofi, dunst, polybar, greenclip, pavucontrol, brightnessctl

## Working with This Repository

When making changes:
1. Configuration changes should maintain the existing modular structure
2. NixOS package additions go in the appropriate `packages/*.nix` file
3. Shell scripts should be executable and follow existing patterns
4. Maintain consistency in theming and color schemes across applications
5. Test window manager configurations before committing (they can break the desktop)

## File Modifications Pattern

The repository uses symbolic links from `~/.config/` to manage configurations. Changes should be made directly in this repository, not in system locations.