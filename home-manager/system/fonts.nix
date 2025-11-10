{
  userConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf userConfig.machineConfig.theme {

    home.packages = with pkgs; [
      dejavu_fonts
      noto-fonts-color-emoji
    ];

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        serif = [
          "DejaVu Sans"
        ];
        sansSerif = [
          "DejaVu Serif"
        ];
        monospace = [
          "DejaVu Sans Mono"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
