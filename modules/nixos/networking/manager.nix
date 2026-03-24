{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];

  networking.networkmanager = {
    enable = true;

    dns = "systemd-resolved";
    unmanaged = [
      # "interface-name:tailscale*"
      # "interface-name:br-*"
      # "interface-name:rndis*"
      "interface-name:docker*"
      # "interface-name:virbr*"
      # "interface-name:vboxnet*"
      "interface-name:waydroid*"
      # "type:bridge"
    ];

    wifi = {
      # iwd or wpa_supplicant
      backend = "wpa_supplicant";
      powersave = false;

      # Random mac address on every boot.
      # macAddress = "random";

      # MAC address randomization of a Wi-Fi device during scanning
      scanRandMacAddress = true;
    };
  };
}
