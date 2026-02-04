{lib, ...}: {
  nix = {
    # Automatic store GC
    gc = {
      automatic = true;
      dates = lib.mkDefault "Sun 03:15";
      randomizedDelaySec = lib.mkDefault "45min";
      options = lib.mkDefault "--delete-older-than 14d";
    };

    # Periodic hard‑link dedup
    optimise = {
      automatic = true;
      dates = lib.mkDefault "Sun 03:45";
      randomizedDelaySec = lib.mkDefault "45min";
    };
  };
}
