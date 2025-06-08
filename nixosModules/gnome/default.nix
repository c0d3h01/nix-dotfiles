{
  pkgs,
  declarative,
  ...
}:

{
  # Enable Gnome, X server
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Exclude unwanted GNOME packages
  environment = {
    gnome.excludePackages = with pkgs; [
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
    ];
  };

  environment.systemPackages =
    with pkgs.gnomeExtensions;
    [
      dash-to-dock
      # user-themes
      # blur-my-shell
      open-bar
    ]
    ++ (with pkgs; [
      gnome-photos
      gnome-tweaks
    ]);

  home-manager.users."${declarative.username}" = {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "gsconnect@andyholmes.github.io"
          "openbar@neuromorph"
          "dash-to-dock@micxgx.gmail.com"
          # "user-theme@gnome-shell-extensions.gcampax.github.com"
          # "blur-my-shell@aunetx"
        ];
      };

      # User themes
      "org/gnome/shell/extensions/user-theme" = {
        name = "WhiteSur-Dark";
      };

      # Dask to Dock
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        intellihide-mode = "ALL-WINDOWS";
      };

      # interface
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-date = true;
        clock-format = "12h";
        color-scheme = "prefer-dark";
      };

      # touchpad
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
        natural-scroll = true;
      };

      # keyboard
      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
      };

      # workspaces
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        workspaces-only-on-primary = true;
      };

      # wallpaper
      # "org/gnome/desktop/background" = {
      #   picture-uri = "file:///home/${declarative.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
      #   picture-uri-dark = "file:///home/${declarative.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
      #   picture-options = "zoom";
      # };
    };

    # Configure XDG portals for the user
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
      config.common.default = "*";
    };
  };
}
