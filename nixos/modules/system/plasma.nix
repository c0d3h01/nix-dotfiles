{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (userConfig.windowManager == "kde") {
    # Plasma desktop environment configuration
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    # X11 session by default
    services.displayManager.defaultSession = "plasmax11";

    # Enable hardware bluetooth
    hardware = {
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    # Exclude unwanted KDE packages
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      kcalc
      konsole
      plasma-browser-integration
      partitionmanager
    ];
  };
}
