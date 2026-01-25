{lib, ...}: let
  inherit (lib) mkForce;
in {
  networking.networkmanager.enable = true;
  # networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager.wifi.powersave = mkForce false;
}
