{ config, pkgs, ... }:

{
  imports = [
    ./system.nix
    ./desktop.nix
    ./development.nix
    ./utilities.nix
    ./theming.nix
  ];
}
