{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix  # Keep hardware config separate
    ./boot.nix
    ./networking.nix
    ./desktop.nix
    ./users.nix
    ./audio.nix
    ./packages/default.nix
    ./appearance.nix
    ./services.nix
  ];

  # System state version - keep this in the main file
  system.stateVersion = "25.05";
  
  # Allow unfree packages - global setting
  nixpkgs.config.allowUnfree = true;

  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];
}
