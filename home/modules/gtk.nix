{
  lib,
  pkgs,
  ...
}:

{
  gtk = {
    enable = true;

    theme = lib.mkForce {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [
          "rimless"
          "black"
        ];
        variant = "macchiato";
      };
    };

    cursorTheme = lib.mkForce {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = lib.mkForce {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = lib.mkForce {
      "gtk-application-prefer-dark-theme" = true;
    };

    gtk4.extraConfig = lib.mkForce {
      "gtk-application-prefer-dark-theme" = true;
    };
  };
}
