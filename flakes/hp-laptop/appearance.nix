{ config, pkgs, lib, ... }:

{
  # Font configuration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Theme configuration - Enable dconf and dbus for theme settings
  programs.dconf.enable = true;
  services.dbus.enable = true;

  # Default GNOME/GTK settings for dark theme
  programs.dconf.profiles = {
    user.databases = [{
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Nordic";
          icon-theme = "Papirus-Dark";
          cursor-theme = "Adwaita";
        };
      };
    }];
  };

  # Environment variables for theming and defaults
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Qt theme settings
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  # Enable and configure GDM
  services.xserver.displayManager.gdm.enable = true;

  # Install required themes and packages
  environment.systemPackages = with pkgs; [
    # Themes
    nordic
    papirus-icon-theme
    gtk-engine-murrine
    
    util-linux
    ncurses
  
    # Configuration tools
    lxappearance
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg
    dconf-editor
  ];
   
  # Configure TTY colors
  console = {
    colors = [
      "2E3440" "BF616A" "A3BE8C" "EBCB8B" 
      "5E81AC" "B48EAD" "88C0D0" "E5E9F0"
      "4C566A" "BF616A" "A3BE8C" "EBCB8B" 
      "81A1C1" "B48EAD" "8FBCBB" "ECEFF4"
    ];
  };
}
