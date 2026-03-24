{pkgs, ...}: {
  # X11: Enable GPU acceleration
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    excludePackages = [pkgs.xterm];
  };
}
