{lib, ...}: {
  nix = {
    gc = {
      automatic = true;
      dates = lib.mkDefault "daily";
      randomizedDelaySec = lib.mkDefault "45min";
      options = lib.mkDefault "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = lib.mkDefault "Sun 04:00";
      randomizedDelaySec = lib.mkDefault "30min";
    };
  };
}
