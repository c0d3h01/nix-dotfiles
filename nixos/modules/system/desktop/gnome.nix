{
  pkgs,
  config,
  lib,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (userConfig.machineConfig.windowManager == "gnome") {

    # GNOME desktop environment configuration
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

    networking.firewall = {
      allowedTCPPorts = [ 1716 ]; # gsconnect / KDE
      allowedUDPPorts = [ 1716 ];
    };

    # Exclude unwanted GNOME packages
    environment = {
      systemPackages = with pkgs; [
        gnome-tweaks
        gnome-photos
        thunderbird
        rhythmbox
      ];

      gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-font-viewer
        epiphany
        yelp
        baobab
        gnome-music
        gnome-remote-desktop
        gnome-usage
        gnome-contacts
        gnome-weather
        gnome-maps
        gnome-connections
        gnome-system-monitor
        gnome-user-docs
        geary
      ];
    };
  };
}

