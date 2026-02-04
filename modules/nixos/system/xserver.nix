{pkgs, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    excludePackages = [pkgs.xterm];
  };
}
