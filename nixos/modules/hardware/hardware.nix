{
  config,
  lib,
  pkgs,
  userConfig,
  modulesPath,
  ...
}:

let
  inherit (lib)
    optionals
    mkIf
    mkDefault
    mkMerge
    ;
  inherit (userConfig.machineConfig) gpuType cpuType;

  # Hardware-specific configurations
  cpuConfig = {
    amd = {
      kernelModules = [ "kvm-amd" ];
      kernelParams = [ "amd_pstate=active" ];
      microcode = config.hardware.cpu.amd.updateMicrocode;
    };
    intel = {
      kernelModules = [ "kvm-intel" ];
      kernelParams = [ "intel_pstate=active" ];
      microcode = config.hardware.cpu.intel.updateMicrocode;
    };
  };

  gpuConfig = {
    amd = {
      kernelModules = [ "amdgpu" ];
      initrdModules = [ "amdgpu" ];
    };
    nvidia = {
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      initrdModules = [ ];
    };
    intel = {
      kernelModules = [ "i915" ];
      initrdModules = [ "i915" ];
    };
  };

  # Current hardware selection
  cpu = cpuConfig.${cpuType} or { };
  gpu = gpuConfig.${gpuType} or { };

  isLaptop = userConfig.machineConfig.laptop.enable;

  # Common configurations
  commonKernelModules = [
    "acpi_call"
    "fuse"
  ];

  commonInitrdModules = [
    "nvme"
    "btrfs"
    "ahci"
    "sd_mod"
    "dm_mod"
    "xhci_pci"
  ];

  commonKernelParams = [
    "nowatchdog"
    "loglevel=7"
    "pti=auto"
    "transparent_hugepage=madvise"

    # Performance
    "pcie_aspm.policy=performance"
    "nvme_core.default_ps_max_latency_us=0"
  ];

  laptopKernelParams = optionals isLaptop [
    "acpi_backlight=native"
    "processor.max_cstate=2"
  ];

  desktopKernelParams = optionals (!isLaptop) [
  ];

in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    # load kernel modules for all detected hardware
    hardwareScan = true;

    # Tmpfs
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      tmpfsSize = mkDefault "75%";
      tmpfsHugeMemoryPages = "within_size";
    };

    kernelModules = commonKernelModules ++ cpu.kernelModules or [ ] ++ gpu.kernelModules or [ ];

    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      cpupower
    ];

    supportedFilesystems = [
      "ntfs"
      "cifs"
      "nfs"
      "exfat"
      "vfat"
    ];

    kernelParams =
      commonKernelParams ++ cpu.kernelParams or [ ] ++ laptopKernelParams ++ desktopKernelParams;

    initrd = {
      verbose = true;
      systemd.enable = true;
      compressor = "zstd";
      compressorArgs = [
        "-3"
        "-T0"
      ];

      kernelModules = commonInitrdModules ++ gpu.initrdModules or [ ];

      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "dm_mod"
        "sr_mod"
        "usbhid"
        "uas"
      ];
    };
  };

  # handle ACPI events
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  networking = {
    useDHCP = mkDefault true;
    dhcpcd.enable = mkDefault true;

    interfaces = {
      enp2s0.useDHCP = mkDefault true;
      wlp3s0.useDHCP = mkDefault true;
    };
  };

  nixpkgs.hostPlatform = mkDefault userConfig.system;

  # CPU microcode updates
  hardware = {
    cpu = {
      amd.updateMicrocode = mkIf (cpuType == "amd") (mkDefault true);
      intel.updateMicrocode = mkIf (cpuType == "intel") (mkDefault true);
    };

    enableRedistributableFirmware = mkDefault true;
  };

  # Intel thermal management for laptops
  services.thermald.enable = mkIf (cpuType == "intel" && isLaptop) (mkDefault true);
}
