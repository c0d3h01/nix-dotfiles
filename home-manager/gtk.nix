{ pkgs, lib, ... }:

{
  gtk = {
    enable = true;

    # theme = lib.mkDefault {
    #   name = "Catppuccin-Mocha-Compact-Mauve-Dark";
    #   package = lib.mkDefault (
    #     pkgs.catppuccin-gtk.override {
    #       accents = [ "mauve" ];
    #       size = "compact";
    #       tweaks = [ "rimless" ];
    #       variant = "mocha";
    #     }
    #   );
    # };

    cursorTheme = lib.mkDefault {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    iconTheme = lib.mkDefault {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = lib.mkDefault {
      "gtk-application-prefer-dark-theme" = true;
    };

    gtk4.extraConfig = lib.mkDefault {
      "gtk-application-prefer-dark-theme" = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
