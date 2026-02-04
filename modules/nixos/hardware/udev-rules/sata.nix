{userConfig, ...}: let
  alpmPolicy =
    if (userConfig.laptop.enable or false)
    then "med_power_with_dipm"
    else "max_performance";
in {
  services.udev.extraRules = ''
    # SATA Active Link Power Management
    ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", \
      ATTR{link_power_management_policy}=="*", \
      ATTR{link_power_management_policy}="${alpmPolicy}"
  '';
}
