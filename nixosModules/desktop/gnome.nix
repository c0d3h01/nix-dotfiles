{
  lib,
  pkgs,
  ...
}:

{
  services = {
    # GNOME desktop environment configuration
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    # Disable gnome initial setup
    gnome.gnome-initial-setup.enable = false;

    # GNOME settings
    gnome.gnome-keyring.enable = true;
    gnome.gnome-remote-desktop.enable = lib.mkForce false;
    gnome.glib-networking.enable = true;
    udev.packages = [ pkgs.gnome-settings-daemon ];

    # Disable xterm
    xserver.desktopManager.xterm.enable = false;
    xserver.excludePackages = [ pkgs.xterm ];
  };

  # Exclude unwanted GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-font-viewer
    epiphany
    yelp
    baobab
    gnome-music
    gnome-remote-desktop
    gnome-usage
    gnome-console
    gnome-contacts
    gnome-weather
    gnome-maps
    gnome-connections
    gnome-system-monitor
    gnome-user-docs
  ];
}
