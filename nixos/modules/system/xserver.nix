{
  pkgs,
  ...
}:
{
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = enable;
    excludePackages = [ pkgs.xterm ];
  };
}
