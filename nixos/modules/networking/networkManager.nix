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

  networking = lib.mkIf (!cfg.wireless.enable) {
    enableIPv6 = true;

    nameservers = [
      "1.1.1.1" # Cloudflare primary
      "1.0.0.1" # Cloudflare secondary
      "8.8.8.8" # Google
    ];

    networkmanager = {
      enable = true;

      plugins = [ pkgs.networkmanager-openvpn ];

      dns = "default";
      appendNameservers = lib.mkForce [];

      # Prevent NetworkManager from overriding our DNS settings
      insertNameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      wifi = {
        # Default is wpa_supplicant
        # inherit (userConfig.machineConfig.networking) backend;
        # use a random mac address on every boot, this can scew with static ip
        # macAddress = "random";
        # Powersaving mode - Disabled
        powersave = lib.mkForce false;
        # MAC address randomization of a Wi-Fi device during scanning
        scanRandMacAddress = true;
      };
    };
  };
}
