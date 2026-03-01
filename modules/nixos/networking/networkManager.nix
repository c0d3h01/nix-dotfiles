{lib, ...}: let
  inherit (lib) mkForce;
in {
  services.resolved.enable = true;
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    wifi = {
      powersave = mkForce false;
      macAddress = "random";
      scanRandMacAddress = true;
    };
    ethernet.macAddress = "random";
  };
}
