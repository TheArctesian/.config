# services.nix
{ config, pkgs, ... }:

{
  # Clipboard manager service
  systemd.user.services.greenclip = {
    enable = true;
    description = "Greenclip daemon";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # Automatically lock screen after inactivity
  services.xserver.xautolock = {
    enable = true;
    time = 10; # Minutes before locking
    locker = "${pkgs.systemd}/bin/loginctl lock-session";
    killtime = 20; # Minutes before sleep
    killer = "${pkgs.systemd}/bin/systemctl suspend";
    extraOptions = [
      "-detectsleep"
      "-notify 30"
      "-notifier '${pkgs.libnotify}/bin/notify-send -u critical -t 10000 \"Screen will lock in 30 seconds\"'"
    ];
  };

  # Configure logind for proper power management
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=lock
      IdleActionSec=300
    '';
  };
  
  # Configure proper screen locking with systemd-logind
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
}
