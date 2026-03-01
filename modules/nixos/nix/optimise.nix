{lib, ...}: {
  nix = {
    # Automatic store GC — daily light pass, weekly deep clean
    gc = {
      automatic = true;
      dates = lib.mkDefault "daily";
      randomizedDelaySec = lib.mkDefault "45min";
      options = lib.mkDefault "--delete-older-than 7d";
    };

    # Periodic hard-link dedup (runs after GC on Sundays)
    optimise = {
      automatic = true;
      dates = lib.mkDefault "Sun 04:00";
      randomizedDelaySec = lib.mkDefault "30min";
    };
  };
}
