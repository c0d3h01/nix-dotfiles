{
  config,
  pkgs,
  userConfig,
  ...
}:
{
  # Enable X server and GNOME
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      xkb.layout = "us";
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0 &&
            subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    });
  '';

  # Exclude unwanted GNOME packages
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-backgrounds
      gnome-font-viewer
      epiphany
      yelp
      baobab
      gnome-weather
      gnome-connections
      gnome-music
      gnome-remote-desktop
      gnome-usage
      gnome-contacts
      gnome-system-monitor
    ];

    systemPackages = with pkgs.stable; [
      # Desktop common Apps
      gnome-photos
      gnome-tweaks
      libreoffice
      rhythmbox
      qbittorrent

      # Gnome extensions
      gnomeExtensions.gsconnect
      gnomeExtensions.dash-to-dock
      gnomeExtensions.just-perfection
    ];

    pathsToLink = [
      "/share/icons"
      "/share/applications"
    ];
  };

  home-manager.users."${userConfig.username}" = {
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "gsconnect@andyholmes.github.io"
          "dash-to-dock@micxgx.gmail.com"
          "just-perfection-desktop@just-perfection"
        ];
      };

      # dash-to-dock
      "org/gnome/shell/extensions/dash-to-dock" = {
        always-center-icons = false;
        apply-custom-theme = true;
        background-opacity = "0.80000000000000004";
        custom-theme-shrink = true;
        dash-max-icon-size = "48";
        dock-fixed = true;
        dock-position = "BOTTOM";
        extend-height = false;
        height-fraction = "0.90000000000000002";
        icon-size-fixed = true;
        intellihide-mode = "ALL_WINDOWS";
        preferred-monitor = "-2";
        preferred-monitor-by-connector = "eDP-1";
        show-trash = true;
      };

      # interface
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-seconds = false;
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
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/${userConfig.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
        picture-uri-dark = "file:///home/${userConfig.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
        picture-options = "zoom";
      };
    };

    # Configure XDG portals for the user
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
      config = {
        common.default = "gnome";
      };
    };
  };
}
