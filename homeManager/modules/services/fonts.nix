{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.programs.hm-fonts.enable = mkEnableOption "Font config";
  config = mkIf config.programs.hm-fonts.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}