{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (userConfig.windowManager == "gnome") {
    # GNOME desktop environment configuration
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    # xdg.portal.enable = true;

    networking.firewall = {
      allowedTCPPorts = [1716]; # KDE connect port
      allowedUDPPorts = [1716];
    };

    # To disable installing GNOME's suite of applications
    # and only be left with GNOME shell.
    services.gnome.core-apps.enable = true;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;

    # Exclude unwanted GNOME packages
    environment = {
      systemPackages = with pkgs; [
        gnome-tweaks
        gnome-console
        gnome-photos
        vlc

        # Gnome extensions
        gnomeExtensions.gsconnect
      ];

      gnome.excludePackages = with pkgs; [
        gnome-tour
        decibels
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
