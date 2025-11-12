{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome
      jetbrains-mono
      material-icons
      maple-mono.NF
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.hack
      terminus_font
      inter
      # Mono space
      nerd-fonts.caskaydia-mono
      # Emoji & Symbols
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "full";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
        monospace = [ "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
