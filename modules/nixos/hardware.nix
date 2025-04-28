{ pkgs, ... }:

{
  # powerManagement.cpuFreqGovernor = "schedutil";

  # ZRAM Swap
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # Fstrim optimization
  services.fstrim.enable = true;

  boot = {
    tmp.cleanOnBoot = true;
    consoleLogLevel = 3;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    initrd = {
      verbose = false;
    };

    kernelParams = [
      "quiet"
      "splash"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 3;
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        consoleMode = "auto";
        editor = false;
      };
    };
  };
}
