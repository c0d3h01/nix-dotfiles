{
  pkgs,
  lib,
  hostProfile,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (hostProfile.windowManager == "plasma") {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm.enable = true;
        sddm.wayland.enable = true;
        defaultSession = "plasmax11";
      };
    };

    environment.systemPackages = with pkgs.kdePackages; [
      kate
      kcalc
      konsole
      plasma-browser-integration
      partitionmanager
      kdeconnect-kde
    ];
  };
}
