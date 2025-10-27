{
  lib,
  userConfig,
  ...
}:
{
  services = lib.mkIf userConfig.machineConfig.workstation.enable {
    printing = {
      enable = false;
      openFirewall = true;
    };

    # Avahi (mDNS) for network printer discovery
    avahi = {
      enable = false;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
  };
}

