{hostProfile, ...}: {
  services = {
    printing = {
      enable = false;
      openFirewall = true;
    };

    avahi = {
      enable = false;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
  };
}
