{
  userConfig,
  pkgs,
  ...
}:
{

  programs.home-manager.enable = true;

  programs.gnome-shell = {
    enable = true;
    extensions = [
      {
        id = "gsconnect@andyholmes.github.io";
        package = pkgs.gnomeExtensions.gsconnect;
      }

      {
        id = "dash-to-dock@micxgx.gmail.com";
        package = pkgs.gnomeExtensions.dash-to-dock;
      }

      {
        id = "forge@jmmaranan.com";
        package = pkgs.gnomeExtensions.forge;
      }
    ];
  };

  home.packages = with pkgs; [
    gnome-photos
    gnome-tweaks
  ];

  dconf.settings = {
    # Power settings
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
    };

    # Night Light
    # "org/gnome/settings-daemon/plugins/color" = {
    #   night-light-enabled = true;
    #   night-light-temperature = 4000;
    #   night-light-schedule-from = "20.0";
    #   night-light-schedule-to = "8.0";
    # };

    # "org/gnome/shell/extensions/dash2dock-lite" = {
    #   calendar-icon = true;
    #   clock-icon = true;
    #   mounted-icon = true;
    #   open-app-animation = true;
    #   edge-distance = 0.48837209302325579;
    #   running-indicator-style = 1;
    # };

    "org/gnome/shell/extensions/dash-to-dock" = {
      background-opacity = 0.8;
      custom-theme-shrink = true;
      dash-max-icon-size = 48;
      dock-fixed = true;
      dock-position = "LEFT";
      extend-height = true;
      height-fraction = 0.61;
      hot-keys = false;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      scroll-to-focused-application = true;
      show-apps-at-top = true;
      show-mounts = true;
      show-show-apps-button = true;
      show-trash = false;
    };

    # interface
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
      clock-show-weekday = true;
      clock-show-date = true;
      clock-format = "12h";
      # enable-animations = false;
      show-battery-percentage = true;
    };

    # touchpad
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      natural-scroll = true;
      disable-while-typing = true;
    };

    # keyboard
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    # workspaces
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = false;
      workspaces-only-on-primary = true;
    };

    # wallpaper
    # "org/gnome/desktop/background" = {
    #   picture-uri = "file:///home/${userConfig.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
    #   picture-uri-dark = "file:///home/${userConfig.username}/dotfiles/assets/wallpapers/Space-Nebula.png";
    #   picture-options = "zoom";
    # };
  };
}
