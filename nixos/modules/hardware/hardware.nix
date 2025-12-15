{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;

    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = ["amdgpu"];
      systemd.enable = true;
      compressor = "zstd";
      compressorArgs = ["-3" "-T0"];
    };

    kernelModules = ["kvm-amd"];

    # Stability-first kernel params
    kernelParams = [
      "quiet"
      "loglevel=3"
      "nowatchdog" # Reduce spurious reboots
      "mitigations=auto" # Security vs performance balance
      "mce=ignore_ce" # Don't panic on corrected CPU errors
      "split_lock_detect=off" # Prevent false-positive lockups
    ];

    # Tmpfs: Conservative 40% (2.4GB) to prevent OOM on 6GB system
    tmp = {
      useTmpfs = true;
      tmpfsSize = "40%";
    };

    supportedFilesystems = ["ntfs" "exfat" "vfat"];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    enableRedistributableFirmware = true;
  };

  # Power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Aggressive disk power management OFF for stability
      DISK_DEVICES = "nvme0n1 sda";
      DISK_APM_LEVEL_ON_AC = "254 254"; # Max performance
      DISK_APM_LEVEL_ON_BAT = "192 192"; # Balanced (not aggressive)

      # WiFi power save OFF for stable connectivity
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";

      # USB autosuspend OFF (prevents device disconnects)
      USB_AUTOSUSPEND = 0;
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = "x86_64-linux";

  # Firmware updates
  services.fwupd = {
    enable = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };

  # ACPI/backlight
  services.acpid.enable = true;
  hardware.acpilight.enable = true;
}
