{
  lib,
  userConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf userConfig.machineConfig.theme {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    # QT theming
    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

    # GTK theming
    gtk = {
      enable = true;

      # Set system UI font
      font = {
        name = "Inter";
        size = 10;
      };

      theme = {
        name = "Orchis-Dark";
        package = pkgs.orchis-theme;
      };

      iconTheme = {
        name = "Tela-circle";
        package = pkgs.tela-circle-icon-theme;
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };
  };
}
