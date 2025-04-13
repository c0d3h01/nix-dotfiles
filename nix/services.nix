{
  pkgs,
  ...
}:
{
  # Printing
  services = {
    printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
        pkgs.hplip
      ];
    };

    # Avahi (mDNS)
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Fstrim optimization
    fstrim.enable = true;
  };
}
