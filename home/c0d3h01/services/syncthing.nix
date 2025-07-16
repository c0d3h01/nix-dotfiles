{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.programs.syncthing;
in
{
  options.programs.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
        command = "syncthingtray --wait";
      };
    };
  };
}
