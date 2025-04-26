{
  config,
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
    ];

    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = lib.mkForce [
          "Noto Serif"
        ];

        sansSerif = lib.mkForce [
          "Noto Sans"
        ];

        monospace = lib.mkForce [
          "Hack"
        ];

        emoji = lib.mkForce [
          "Twitter Color Emoji"
        ];
      };

      hinting = {
        enable = true;
        style = "slight";
      };

      antialias = true;
      subpixel = {
        rgba = "rgb";
      };
    };
  };
}
