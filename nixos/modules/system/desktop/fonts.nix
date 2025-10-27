{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # Mono space
      nerd-fonts.caskaydia-mono

      # Emoji & Symbols
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
    ];

    fontconfig = {
      enable = true;
      antialias = true;

      hinting = {
        enable = true;
        style = "slight";
      };

      defaultFonts = {
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        monospace = [ "Caskaydia Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}

