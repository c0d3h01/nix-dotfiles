{
  config,
  lib,
  pkgs,
  userConfig,
  modulesPath,
  ...
}:
let
  inherit (lib) optionals mkIf mkDefault;

  # Get CPU & GPU types
  inherit (userConfig.machineConfig) gpuType;
  inherit (userConfig.machineConfig) cpuType;

  # Dynamic kernel modules based on hardware
  cpuKernelModules =
    optionals (cpuType == "amd") [
      "kvm-amd"
    ]
    ++ optionals (cpuType == "intel") [
      "kvm-intel"
    ];

  gpuKernelModules =
    optionals (gpuType == "amd") [
      "amdgpu"
    ]
    ++ optionals (gpuType == "nvidia") [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ]
    ++ optionals (gpuType == "intel") [
      "i915"
    ];

  # Dynamic kernel parameters
  cpuKernelParams =
    optionals (cpuType == "amd") [
      "amd_pstate=active"
    ]
    ++ optionals (cpuType == "intel") [
      "intel_pstate=active"
    ];

  isLaptop = userConfig.machineConfig.laptop.enable;

  laptopKernelParams = optionals isLaptop [
    "acpi_backlight=native"
    "processor.max_cstate=2" # Better responsiveness
  ];
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    # Clean tmp dir on boot
    tmp.cleanOnBoot = true;

    kernelModules = [
      "acpi_call"
      "fuse"
    ]
    ++ cpuKernelModules
    ++ gpuKernelModules;

    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      cpupower
    ];

    supportedFilesystems = [
      "ntfs"
      "cifs"
      "nfs"
    ];

    kernelParams = [
      "nowatchdog"
      "splash"
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "pti=auto"
      "usbcore.autosuspend=-1"
      "pcie_aspm=performance"
    ]
    ++ cpuKernelParams
    ++ laptopKernelParams;

    initrd = {
      verbose = false;
      compressor = "zstd";
      compressorArgs = [
        "-3"
        "-T0"
      ];

      kernelModules = [
        "nvme"
        "btrfs"
        "ahci"
        "sd_mod"
        "dm_mod"
        "xhci_pci"
      ]
      ++ optionals (gpuType == "amd") [ "amdgpu" ]
      ++ optionals (gpuType == "intel") [ "i915" ];

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

  # Use tmpfs
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=1777" "size=4G" ];
  };

  # Network configuration
  networking.useDHCP = mkDefault true;
  networking.dhcpcd.enable = mkDefault true;

  networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  # Platform detection
  nixpkgs.hostPlatform = mkDefault userConfig.system;

  # CPU microcode updates - dynamic based on CPU type
  hardware.cpu.amd.updateMicrocode = mkIf (cpuType == "amd") true;
  hardware.cpu.intel.updateMicrocode = mkIf (cpuType == "intel") true;

  # Enable firmware updates
  hardware.enableRedistributableFirmware = mkDefault true;

  # Intel thermal management
  services.thermald.enable = mkIf (cpuType == "intel" && isLaptop) true;
}
