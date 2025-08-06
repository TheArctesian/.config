{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim             
    neovim
    keepmenu
    wget
    fish
    brightnessctl
    acpi
    powertop
    networkmanagerapplet
    docker
    docker-compose
  ];
  
  # Enable Docker daemon
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2"; # More efficient than the default on most filesystems
    # Optional: enable docker compose as a plugin (modern approach)
    enableOnBoot = true; # Start Docker on boot
  };
  
  # Add your user to the "docker" group to run docker without sudo
   users.users.okita.extraGroups = [ "docker" ];
}
