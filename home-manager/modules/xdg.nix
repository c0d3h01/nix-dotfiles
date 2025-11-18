{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;

in
{
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = mkIf isLinux {
      enable = true;
      createDirectories = true;

      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      desktop = "${config.home.homeDirectory}/Desktop";
      videos = "${config.home.homeDirectory}/Media/Videos";
      music = "${config.home.homeDirectory}/Media/Music";
      pictures = "${config.home.homeDirectory}/Media/Pictures";
      publicShare = "${config.home.homeDirectory}/Public/Share";
      templates = "${config.home.homeDirectory}/Public/Templates";

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        XDG_DEV_DIR = "${config.home.homeDirectory}/Dev";
        XDG_GITDEV_DIR = "${config.home.homeDirectory}/Dev/GitHub";
      };
    };
  };
}
