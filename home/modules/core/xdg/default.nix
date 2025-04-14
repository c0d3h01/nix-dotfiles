{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
      config = {
        common.default = "gnome";
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/x-bittorrent" = "transmission-gtk.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
      };
    };
  };
}
