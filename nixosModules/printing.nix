{ pkgs, ... }:

{
  services = {
    printing = {
      enable = true;
      openFirewall = true;
      drivers = with pkgs; [
        gutenprint
        hplip
      ];
    };

    # Avahi (mDNS)
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
