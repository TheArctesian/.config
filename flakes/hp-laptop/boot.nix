{ config, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # LUKS encryption
  boot.initrd.luks.devices."luks-6120a2c7-e0c9-4701-a9ff-46357bf9699d".device = "/dev/disk/by-uuid/6120a2c7-e0c9-4701-a9ff-46357bf9699d";
}
