{
  pkgs,
  ...
}:
{

  programs.gnome-shell = {
    enable = true;
    extensions = [
      {
        id = "ding@rastersoft.com";
        package = pkgs.gnomeExtensions.desktop-icons-ng-ding;
      }

      {
        id = "gsconnect@andyholmes.github.io";
        package = pkgs.gnomeExtensions.gsconnect;
      }

      # {
      #   id = "dash-to-dock@micxgx.gmail.com";
      #   package = pkgs.gnomeExtensions.dash-to-dock;
      # }

      {
        id = "dash2dock-lite@icedman.github.com";
        package = pkgs.gnomeExtensions.dash2dock-lite;
      }

      # {
      #   id = "forge@jmmaranan.com";
      #   package = pkgs.gnomeExtensions.forge;
      # }
    ];
  };

  dconf.settings = {
    # Power settings
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
    };

    "org/gnome/shell/extensions/dash2dock-lite" = {
      calendar-icon = true;
      clock-icon = true;
      mounted-icon = true;
      open-app-animation = true;
      edge-distance = 0.4;
      running-indicator-style = 1;
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
  };
}
