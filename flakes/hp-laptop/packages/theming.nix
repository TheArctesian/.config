# packages/theming.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Theme-related packages
    nordic
    papirus-icon-theme
    gtk-engine-murrine
    lxappearance
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    dconf-editor
  ];
}
