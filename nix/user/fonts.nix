{ config, lib, pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;

    packages = with pkgs; [
      # Sans-serif fonts
      inter

      # Serif fonts
      source-serif-pro

      # Monospace fonts
      fira-code

      # Extended character support
      noto-fonts
      noto-fonts-emoji

      # Fallback fonts
      dejavu_fonts
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };

      defaultFonts = {
        serif = lib.mkForce [ "Source Serif Pro" "DejaVu Serif" ];
        sansSerif = lib.mkForce [ "Inter" "DejaVu Sans" ];
        monospace = lib.mkForce [ "Fira Code" "DejaVu Sans Mono" ];
        emoji = lib.mkForce [ "Noto Color Emoji" ];
      };

      # Font rendering
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
  };
}
