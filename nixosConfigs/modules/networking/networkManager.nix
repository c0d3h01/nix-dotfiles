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
  # Ensures Wi-Fi adheres to your country's power/channel rules
  hardware.wirelessRegulatoryDatabase = true;

  networking = lib.mkIf (!cfg.wireless) {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = [ pkgs.networkmanager-openvpn ];

      wifi = {
        # Default is wpa_supplicant
        # inherit (userConfig.machineConfig.networking) backend;
        # use a random mac address on every boot, this can scew with static ip
        macAddress = "random";
        # Powersaving mode - Disabled
        powersave = lib.mkForce false;
        # MAC address randomization of a Wi-Fi device during scanning
        scanRandMacAddress = true;
      };
    };
  };
}
