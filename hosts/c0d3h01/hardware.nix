{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    tmp.cleanOnBoot = true;
    consoleLogLevel = 3;
    # kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernelParams = [
      "quiet"
      "splash"
      "nowatchdog"
      "loglevel=3"
      "mitigations=off"
      "nohz_full=4-7"
    ];

    kernel.sysctl = { };

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

    initrd = {
      verbose = false;
      kernelModules = [ ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
    };
  };

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
