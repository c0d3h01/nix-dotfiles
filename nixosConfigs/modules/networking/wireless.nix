{
  lib,
  userConfig,
  ...
}:
let
  cfg = userConfig.machineConfig;
  enable = cfg.type == "server";
in
{
  networking.wireless = lib.mkIf cfg.networking.wireless {
    # wpa_supplicant
    enable = cfg.networking.backend == "wpa_supplicant";

    # Allow user to manage networks via `nmcli` or GUI
    userControlled.enable = true;

    # Allow imperative commands like `iwlist scan`, `nmcli dev wifi connect`
    allowAuxiliaryImperativeNetworks = true;

    # wpa_supplicant: Save network config in /etc/NetworkManager/system-connections/
    extraConfig = ''
      update_config=1
    '';

    # iwd
    iwd = {
      enable = cfg.networking.backend == "iwd";

      settings = {
        Settings.AutoConnect = true;

        General = {
          # AddressRandomization = "network";
          # AddressRandomizationRange = "full";

          # Enable dynamic IP + IPv6 router-based config
          EnableNetworkConfiguration = true;
          RoamRetryInterval = 15;
        };

        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
      };
    };
  };
}
