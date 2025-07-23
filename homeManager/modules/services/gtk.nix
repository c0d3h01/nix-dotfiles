{
  config,
  pkgs,
  ...
}:
let
  inherit (config.lib.nixGL) wrap;
in
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = wrap pkgs.bibata-cursors;
    size = 24;
  };

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-Dark";
      package = wrap pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = wrap pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = wrap pkgs.bibata-cursors;
      size = 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
