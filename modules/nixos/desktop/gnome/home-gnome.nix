{
  config,
  pkgs,
  lib,
  userConfig,
  ...
}:
{
  home.packages = with pkgs; [
    # Gnome extensions here
    gnomeExtensions.gsconnect
    gnomeExtensions.dash-to-dock
  ];

  # Use dconf settings for user-specific GNOME config
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "gsconnect@andyholmes.github.io"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };

    # dash-to-dock
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      custom-theme-shrink = true;
      intellihide-mode = "ALL_WINDOWS";
      show-trash = false;
    };

    # interface
    "org/gnome/desktop/interface" = {
      enable-hot-corners = true;
      clock-show-weekday = true;
      clock-show-seconds = false;
      clock-show-date = true;
      clock-format = "12h";
      color-scheme = "prefer-dark";
    };

    # touchpad
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      natural-scroll = true;
    };

    # keyboard
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    # workspaces
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
    };

    # wallpaper
    "org/gnome/desktop/background" = {
      # Use Home Manager's config.home.homeDirectory
      picture-uri = "file://${config.home.homeDirectory}/dotfiles/assets/wallpapers/Space-Nebula.png";
      picture-uri-dark = "file://${config.home.homeDirectory}/dotfiles/assets/wallpapers/Space-Nebula.png";
      picture-options = "zoom";
    };
  };

  # Configure XDG portals for the user
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
    config = {
      common.default = "gnome";
    };
  };
}
