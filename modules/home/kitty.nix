{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.home.features.kitty;
in {
  options.dotfiles.home.features.kitty = {
    enable = mkEnableOption "Kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.wrapWithNixGL pkgs.kitty "kitty";

      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+w" = "close_tab";
        "ctrl+shift+right" = "next_tab";
        "ctrl+shift+left" = "previous_tab";
        "ctrl+shift+1" = "goto_tab 1";
        "ctrl+shift+2" = "goto_tab 2";
        "ctrl+shift+3" = "goto_tab 3";
        "ctrl+shift+4" = "goto_tab 4";
        "ctrl+shift+5" = "goto_tab 5";
        "ctrl+shift+6" = "goto_tab 6";
        "ctrl+shift+7" = "goto_tab 7";
        "ctrl+shift+8" = "goto_tab 8";
        "ctrl+shift+9" = "goto_tab 9";
        "ctrl+shift+enter" = "new_window";
        "ctrl+shift+," = "set_tab_title";
        "ctrl+shift+equal" = "change_font_size all +1.0";
        "ctrl+shift+minus" = "change_font_size all -1.0";
        "ctrl+shift+0" = "change_font_size all 0";
      };
    };
  };
}
