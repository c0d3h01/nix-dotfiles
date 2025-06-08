{ pkgs, lib, ... }:

{
  services.desktopManager.plasma6.enable = lib.mkDefault true;
  services.displayManager.sddm.enable = lib.mkDefault true;
  environment.gnome.excludePackages = with pkgs; [
    kdePackages.kate
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
