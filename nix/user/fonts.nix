{ config, lib, pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;

    packages = with pkgs; [
      inter
      source-serif-pro
      fira-code
      twitter-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = lib.mkForce [ "Source Serif Pro" ];
        sansSerif = lib.mkForce [ "Inter" ];
        monospace = lib.mkForce [ "Fira Code" ];
        emoji = lib.mkForce [ "Twitter Color Emoji" ];
      };
    };
  };
}
