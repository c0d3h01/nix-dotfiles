{
  pkgs,
  config,
  lib,
  userConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (userConfig.machineConfig.windowManager == "xfce") {
    nixpkgs.config.pulseaudio = true;
    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
    };
    services.displayManager.defaultSession = "xfce";
  };
}
