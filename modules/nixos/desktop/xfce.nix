{
  lib,
  userConfig,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (userConfig.windowManager == "xfce") {
    # XFCE desktop environment
    services.xserver.desktopManager.xfce.enable = true;
    services.displayManager.defaultSession = "xfce";
  };
}
