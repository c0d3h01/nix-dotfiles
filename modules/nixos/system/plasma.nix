{
  config,
  pkgs,
  lib,
  hostProfile,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (hostProfile.windowManager == "plasma") {
    services.desktopManager.plasma6.enable = true;
    services.displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
      defaultSession = "plasmax11";
    };

    programs.kdeconnect.enable = true;
    networking.firewall = mkIf config.networking.firewall.enable {
      allowedTCPPorts = [1716];
      allowedUDPPorts = [1716];
    };

    environment.systemPackages = with pkgs; [
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.konsole
      kdePackages.plasma-browser-integration
      kdePackages.partitionmanager
      kdePackages.kpat # card game
      kdePackages.sonnet # spellchecker
      gnome-logs
      libreoffice-still
      vlc
    ];
  };
}
