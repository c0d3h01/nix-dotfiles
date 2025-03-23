{ config, username, pkgs, ... }:

{
  # Enable X server and GNOME
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.xkb.layout = "us";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable dconf service for GNOME settings management
  programs.dconf.enable = true;

  # Exclude unwanted GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-backgrounds
    gnome-font-viewer
    epiphany
    geary
    yelp
    baobab
    gnome-weather
    gnome-connections
    gnome-contacts
    gnome-system-monitor
  ];

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  # Additional system packages
  environment.systemPackages = with pkgs; [
    gnome-photos
    gnome-tweaks
    evolutionWithPlugins
    libreoffice

    # Gnome Extensions
    gnomeExtensions.gsconnect
    gnomeExtensions.dash2dock-lite
  ];

  home-manager.users.${username} = { pkgs, ... }: {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "gsconnect@andyholmes.github.io"
          "dash2dock-lite@icedman.github.com"
        ];
      };

      # Set interface
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
      };

      # Set wallpaper
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.users.users.${username}.home}/dotfiles/assets/wallpaper.png";
        picture-uri-dark = "file://${config.users.users.${username}.home}/dotfiles/assets/wallpaper.png";
      };

      # Set screensaver
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${config.users.users.${username}.home}/dotfiles/assets/wallpaper.png";
        primary-color = "#8a0707";
        secondary-color = "#000000";
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "palenight";
        package = pkgs.palenight-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };
      gtk3.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
      };
    };
  };
}
