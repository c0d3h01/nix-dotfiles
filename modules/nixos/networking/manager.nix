{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    unmanaged = [
      "interface-name:docker*"
      "interface-name:waydroid*"
    ];

    wifi = {
      backend = "wpa_supplicant"; # iwd | wpa_supplicant
      powersave = false;
      # macAddress = "random";
      scanRandMacAddress = true;
    };
  };
}
