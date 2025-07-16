{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.programs.gnome-settings;
in
{
  options.programs.gnome-settings = {
    enable = mkEnableOption "enable gnome shell settings";
  };

  config = mkIf cfg.enable {
    programs.gnome-shell = {
      enable = true;
      extensions = [
        {
          id = "gsconnect@andyholmes.github.io";
          package = pkgs.gnomeExtensions.gsconnect;
        }
        {
          id = "dash2dock-lite@icedman.github.com";
          package = pkgs.gnomeExtensions.dash2dock-lite;
        }
        # {
        #   id = "dash-to-dock@micxgx.gmail.com";
        #   package = pkgs.gnomeExtensions.dash-to-dock;
        # }
        # {
        #   id = "forge@jmmaranan.com";
        #   package = pkgs.gnomeExtensions.forge;
        # }
      ];
    };

    dconf.settings = {
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

      "org/gnome/shell/extensions/dash2dock-lite" = {
        calendar-icon = true;
        clock-icon = true;
        mounted-icon = true;
        open-app-animation = true;
        edge-distance = 0.48837209302325579;
        running-indicator-style = 1;
      };

      # "org/gnome/shell/extensions/dash-to-dock" = {
      #   custom-theme-shrink = true;
      #   dock-position = "BOTTOM";
      #   show-mounts = true;
      #   show-trash = false;
      # };

      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-date = true;
        clock-format = "12h";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
        natural-scroll = true;
        disable-while-typing = true;
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
      };
    };
  };
}
