{
  pkgs,
  lib,
  userConfig,
  ...
}:
let
  cfg = userConfig.machineConfig.networking;
in
{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";

    wifi = {
      # Default is wpa_supplicant
      inherit (cfg) backend;

      # use a random mac address on every boot, this can scew with static ip
      # macAddress = "random";

      # Powersaving mode - Disabled
      powersave = lib.mkForce false;

      # MAC address randomization of a Wi-Fi device during scanning
      scanRandMacAddress = false;
    };
  };
}
