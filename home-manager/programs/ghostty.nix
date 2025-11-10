{
  config,
  userConfig,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.lib.nixGL) wrap;
  inherit (lib) mkIf;
in
{
  config = mkIf userConfig.machineConfig.glApps {
    programs.ghostty = {
      enable = true;
      package = wrap pkgs.ghostty;
      enableZshIntegration = true;

      settings = {
        font-family = "DejaVu Sans Mono";
        font-size = 12;
        theme = "Belafonte Night";
        mouse-hide-while-typing = true;
        gtk-titlebar = true;
        background-opacity = 0.85;
        background-blur-radius = 20;
        macos-option-as-alt = true;
        macos-non-native-fullscreen = "visible-menu";

        keybind = [
          # Clipoard
          "super+c=copy_to_clipboard"
          "super+v=paste_from_clipboard"

          "super+zero=reset_font_size"
          "super+q=quit"
          "super+shift+comma=reload_config"
          "super+k=clear_screen"

          # Tabs
          "super+t=new_tab"
          "super+n=new_window"
          "super+w=close_surface"
          "super+shift+w=close_window"

          # Tabs position
          "super+shift+r=new_split:right"
          "super+shift+l=new_split:right"
          "super+shift+d=new_split:down"

          # Tab Brackets
          "super+right_bracket=goto_split:next"
          "super+left_bracket=goto_split:previous"
          "super+shift+left_bracket=previous_tab"
          "super+shift+right_bracket=next_tab"
        ];
      };
    };
  };
}
