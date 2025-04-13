{
  lib,
  pkgs,
  ...
}:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Main fonts
      dejavu_fonts
      hack-font
      twitter-color-emoji

      # Programming fonts
      jetbrains-mono
      fira-code
      iosevka
      source-code-pro

      # UI fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      roboto
      open-sans

      # Icon fonts
      material-design-icons
      font-awesome

      # Nerd fonts (for terminal icons)
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.droid-sans-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = lib.mkForce [
          "Noto Serif"
          "DejaVu Serif"
        ];
        sansSerif = lib.mkForce [
          "Noto Sans"
          "DejaVu Sans"
        ];
        monospace = lib.mkForce [
          "JetBrains Mono"
          "Fira Code"
          "Hack"
        ];
        emoji = lib.mkForce [
          "Twitter Color Emoji"
          "Noto Color Emoji"
        ];
      };
      hinting = {
        enable = true;
        style = "slight";
      };
      antialias = true;
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
  };
}
