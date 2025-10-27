{
  lib,
  pkgs,
  userConfig,
  ...
}:
{
  xdg.portal = lib.mkIf userConfig.machineConfig.workstation.enable {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}

