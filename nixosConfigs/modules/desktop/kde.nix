{
  pkgs,
  config,
  lib,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  config = mkIf (userConfig.desktop.windowManager == "kde") {
    services = {
      desktopManager.plasma6.enable = lib.mkDefault true;
      displayManager.sddm.enable = lib.mkDefault true;
      xserver.enable = true;
    };

    # Exclude unwanted KDE packages
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      konsole
      kwrite
      plasma-browser-integration
    ];
  };
}
