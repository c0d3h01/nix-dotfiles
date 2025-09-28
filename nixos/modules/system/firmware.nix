{ config, ... }:
{
  # firmware updater for machine hardware
  services.fwupd = {
    enable = false;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
  };
}
