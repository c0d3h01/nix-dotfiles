# Hardware — base platform detection, initrd, firmware, tmpfs
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    # keep-sorted start
    (modulesPath + "/installer/scan/not-detected.nix")
    # keep-sorted end
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "btrfs"
        "sd_mod"
        "dm_mod"
      ];
      systemd.enable = true;
      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];
    };

    kernelModules = lib.mkMerge [
      (lib.mkIf (config.hardware.cpu.amd.updateMicrocode or false) ["kvm-amd"])
      (lib.mkIf (config.hardware.cpu.intel.updateMicrocode or false) ["kvm-intel"])
    ];

    # Kernel parameters — disable mitigations for performance on trusted machines
    kernelParams = lib.mkDefault [
      "mitigations=off"
    ];

    # Tmpfs — use RAM-backed /tmp for faster builds, reduce disk wear
    tmp = {
      useTmpfs = true;
      tmpfsSize = "60%";
      tmpfsHugeMemoryPages = "within_size";
    };

    supportedFilesystems = ["ntfs" "exfat" "vfat"];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    enableRedistributableFirmware = true;
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Firmware updates via fwupd
  services.fwupd = {
    enable = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };

  # ACPI / backlight control
  services.acpid.enable = true;
  hardware.acpilight.enable = true;
}
