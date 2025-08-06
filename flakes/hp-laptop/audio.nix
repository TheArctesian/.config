# audio.nix
{ config, pkgs, ... }:

{
  # Sound configuration with PipeWire and ALSA
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;  # PulseAudio compatibility
    jack.enable = true;   # JACK compatibility
  };
  
  # Sound control tools
  environment.systemPackages = with pkgs; [
    alsa-utils      # Contains amixer for ALSA volume control
    pamixer         # Pulseaudio CLI mixer
    pavucontrol     # GUI for PulseAudio
  ];
}
