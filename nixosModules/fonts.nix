{
  lib,
  pkgs,
  ...
}:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      # enable = true;

      defaultFonts = {
        serif = [
          "Noto Serif"
        ];
        sansSerif = [
          "Noto Sans"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
