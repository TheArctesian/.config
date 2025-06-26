#!/usr/bin/env bash

# Define the theme state file
THEME_STATE_FILE="$HOME/.config/theme_state"

# Check if theme state file exists, create it if not
if [ ! -f "$THEME_STATE_FILE" ]; then
    echo "dark" > "$THEME_STATE_FILE"
fi

# Read current theme state
CURRENT_THEME=$(cat "$THEME_STATE_FILE")

if [ "$CURRENT_THEME" = "dark" ]; then
    # Switch to light theme
    echo "light" > "$THEME_STATE_FILE"
    
    # Write GTK settings
    mkdir -p "$HOME/.config/gtk-3.0"
    cat > "$HOME/.config/gtk-3.0/settings.ini" << EOF
[Settings]
gtk-theme-name=Arc
gtk-icon-theme-name=Papirus
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-application-prefer-dark-theme=0
EOF

    # Set Qt theme (using qt5ct configuration)
    mkdir -p "$HOME/.config/qt5ct"
    cat > "$HOME/.config/qt5ct/qt5ct.conf" << EOF
[Appearance]
icon_theme=Papirus
standard_dialogs=default
style=kvantum-arc

[Fonts]
fixed="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
general="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
EOF

    # Update Kvantum theme
    mkdir -p "$HOME/.config/Kvantum"
    echo "[General]
theme=Arc" > "$HOME/.config/Kvantum/kvantum.kvconfig"
    
    echo "󰖨" # Sun icon for light mode
else
    # Switch to dark theme
    echo "dark" > "$THEME_STATE_FILE"
    
    # Write GTK settings
    mkdir -p "$HOME/.config/gtk-3.0"
    cat > "$HOME/.config/gtk-3.0/settings.ini" << EOF
[Settings]
gtk-theme-name=Nordic
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-application-prefer-dark-theme=1
EOF

    # Set Qt theme
    mkdir -p "$HOME/.config/qt5ct"
    cat > "$HOME/.config/qt5ct/qt5ct.conf" << EOF
[Appearance]
icon_theme=Papirus-Dark
standard_dialogs=default
style=kvantum-dark

[Fonts]
fixed="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
general="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
EOF

    # Update Kvantum theme
    mkdir -p "$HOME/.config/Kvantum"
    echo "[General]
theme=KvGnomeDark" > "$HOME/.config/Kvantum/kvantum.kvconfig"
    
    echo "☾" # Moon icon for dark mode
fi
