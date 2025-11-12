{
  pkgs,
  ...
}:
{
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = true;
    excludePackages = [ pkgs.xterm ];
  };
}
