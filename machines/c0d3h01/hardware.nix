{
  inputs,
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
    algorithm = "lzo-rle";
    memoryPercent = 180;
  };

  # enables AMDVLK & OpenCL support
  hardware.graphics.extraPackages = [
    pkgs.rocmPackages.clr
    pkgs.rocmPackages.clr.icd
  ];

  boot.loader = {
    timeout = lib.mkForce 5;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ]; # For UEFI
      useOSProber = true;
      memtest86.enable = true;
    };

    systemd-boot = {
      enable = false;
      configurationLimit = 15; # Limit the number of entries in the boot menu
      memtest86.enable = true; # Enable memtest86+ in the boot menu
      consoleMode = "auto"; # Automatically detect the console mode
    };
  };

  boot = {
    # Clean Tmp dir on boot
    tmp.cleanOnBoot = true;

    # Nixos kernel configuration
    kernelPackages = with pkgs; linuxPackages_latest;

    kernelModules = [
      "kvm-amd"
      "amdgpu"
      "amd-pstate"
      "acpi_cpufreq" # CPU frequency scaling
      "fuse" # Filesystem in Userspace
    ];
    extraModulePackages = [ ];
    supportedFilesystems = [
      "ntfs"
      "cifs"
      "nfs"
    ];

    kernelParams = [
      "nowatchdog"
      "mitigations=off"
      "splash"

      # tell the kernel to not be verbose, the voices are too loud
      "quiet"

      # kernel log message level
      "loglevel=3" # 1: system is unusable | 3: error condition | 7: very verbose

      # udev log message level
      "udev.log_level=3"

      # lower the udev log level to show only errors or worse
      "rd.udev.log_level=3"

      # Disable usb autosuspend
      "usbcore.autosuspend=-1"

      # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
      # Automatically decide the pti state
      "pti=auto" # options: auto | on | off

      # enable IOMMU for devices used in passthrough and provide better host performance
      "iommu=pt"

      # allow systemd to set and save the backlight state
      "acpi_backlight=native"
    ];

    initrd = {
      verbose = false;

      compressor = "zstd";
      compressorArgs = [
        "-19"
        "-T0"
      ];

      kernelModules = [
        "nvme"
        "btrfs"
        "amdgpu"
        "ahci"
        "sd_mod"
        "dm_mod"
        "xhci_pci"
      ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "dm_mod"
        "sr_mod"
      ];
    };
  };

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
