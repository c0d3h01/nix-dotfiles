{
  userConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = userConfig.machineConfig;
in
{
  config = mkIf (cfg.windowManager == "gnome" && cfg.theme) {

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
          id = "appindicatorsupport@rgcjonas.gmail.com";
          package = pkgs.gnomeExtensions.appindicator;
        }
        {
          id = "clipboard-indicator@tudmotu.com";
          package = pkgs.gnomeExtensions.clipboard-indicator;
        }
        # {
        #   id = "dash2dock-lite@icedman.github.com";
        #   package = pkgs.gnomeExtensions.dash2dock-lite;
        # }
      ];
    };

    dconf.settings = {
      # Power settings
      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "interactive";
      };

      # "org/gnome/shell/extensions/dash2dock-lite" = {
      #   calendar-icon = true;
      #   clock-icon = true;
      #   mounted-icon = true;
      #   open-app-animation = true;
      #   edge-distance = 0.4;
      #   running-indicator-style = 1;
      # };

      # interface
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = true;
        clock-show-weekday = true;
        clock-show-date = true;
        clock-format = "12h";
        enable-animations = false;
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
  };
}
