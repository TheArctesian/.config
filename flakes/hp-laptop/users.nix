{ config, pkgs, ... }:

{
  # Define a user account
  users.users.okita = {
    isNormalUser = true;
    description = "okita";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [];
  };
}
