{ pkgs, ... }:
{
  # fonts.packages = with pkgs; [
  #   jetbrains-mono
  #   nerd-fonts
  #   # nerd-fonts-cjk-sans
  #   # noto-fonts-cjk-serif
  #   # noto-fonts-color-emoji
  #   # noto-fonts-emoji # emoji fallback
  #   # liberation_ttf # Common document fonts
  # ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu_font_family
      liberation_ttf
      # Persian Font
      vazir-fonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Liberation Serif"
          "Vazirmatn"
        ];
        sansSerif = [
          "Ubuntu"
          "Vazirmatn"
        ];
        monospace = [ "Ubuntu Mono" ];
      };
    };
  };
}
