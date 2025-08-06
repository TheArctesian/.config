# packages/desktop.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Window Manager and Desktop Environment
    bspwm
    sxhkd
    polybar
    picom
    feh
    alacritty
    rofi
    dunst           # For notifications
    xdo
    libnotify       # For sending notifications
    
    # Fun
    cava 
    fortune
    neo-cowsay 
    cbonsai
    wtfutil
    sl
    hollywood
    
    # Applications
    firefox
    brave
    zoom-us
    obsidian
    zotero
    slack
    tor-browser
    signal-desktop 
    signal-cli
    gurk-rs
    ghostty
    obs-studio
    libreoffice
    zathura
    
    # Media controls
    playerctl
  ];
  
  # Define these services properly
  services.blueman.enable = true;
}
