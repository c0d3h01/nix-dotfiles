{
  lib,
  userConfig,
  pkgs,
  ...
}:
{
  services.xserver = lib.mkIf userConfig.machineConfig.workstation.enable {
    enable = false;
    desktopManager.xterm.enable = false;
    excludePackages = [ pkgs.xterm ];
  };
}
