{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Terminal utilities
    xclip
    neofetch
    pfetch
    zoxide
    starship
    eza
    lsd
    bat
    xh
    zellij
    dust
    fd
    ripgrep
    yazi            # File manager
    dua
    gitui
    tty-clock
    cmatrix
    ncspot
    haskellPackages.greenclip
    btop
    gotop
    imgcat
    flameshot
    mplayer
    scrot     # For taking screenshots (used in lock script)
    imagemagick # For image processing in lock script
  ];
}
