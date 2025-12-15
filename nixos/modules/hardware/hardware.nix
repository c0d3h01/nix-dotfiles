{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # === BOOT CONFIGURATION ===
  boot = {
    # Kernel version
    kernelPackages = pkgs.linuxPackages_6_12;

    # Kernel modules
    initrd.availableKernelModules = [
      "nvme"
      "ahci"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["kvm-amd"];

    # Kernel parameters
    kernelParams = [
      "quiet"
      "loglevel=3"
      "nowatchdog"
      "mitigations=auto"
    ];

    # Initrd optimization
    initrd.systemd.enable = true;
    initrd.compressor = "zstd";
    initrd.compressorArgs = ["-19" "-T0"];

    # Tmpfs
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };

    # Filesystem support
    supportedFilesystems = ["ntfs" "exfat" "vfat"];
  };

  # === HARDWARE FEATURES ===
  hardware = {
    # AMD CPU microcode updates
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # Enable all firmware (WiFi, Bluetooth, etc.)
    enableRedistributableFirmware = true;

    # Graphics
    amdgpu.amdvlk.enable = false;
    graphics.enable = true;
  };

  # === POWER MANAGEMENT ===
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "schedutil";
  };

  # Battery optimization
  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";

      # AMD P-State (Zen+ uses acpi-cpufreq, not amd-pstate)
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      # Boost control
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Disk
      DISK_DEVICES = "nvme0n1 sda";
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
    };
  };

  # === NETWORKING ===
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true; # GUI network management

    # Interface names from your system
    interfaces = {
      enp2s0.useDHCP = lib.mkDefault true; # Ethernet
      wlp3s0.useDHCP = lib.mkDefault true; # WiFi
    };
  };

  # === SYSTEM PROFILE ===
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # firmware updater for machine hardware
  services.fwupd = {
    enable = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };

  # === THERMAL/BACKLIGHT ===
  services.acpid.enable = true; # ACPI event handling
  hardware.acpilight.enable = true; # Backlight control via /sys
}
