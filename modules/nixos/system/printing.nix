{
  lib,
  hostProfile,
  ...
}: {
  services = lib.mkIf hostProfile.isWorkstation {
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
