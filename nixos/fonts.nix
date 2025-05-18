{
  lib,
  pkgs,
  ...
}:

{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = false;

    packages = with pkgs; [
      hack-font
      twitter-color-emoji
      noto-fonts
      noto-fonts-cjk-sans
      inter
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = lib.mkForce [
          "Noto Serif"
        ];

        sansSerif = lib.mkForce [
          "Inter"
          "Noto Sans"
        ];

        monospace = lib.mkForce [
          "Hack"
        ];

        emoji = lib.mkForce [
          "Twitter Color Emoji"
        ];
      };
    };
  };
}
