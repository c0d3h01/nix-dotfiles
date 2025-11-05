{ pkgs, ... }:
{
  nix = {
    # Automatic store GC + optimisation
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Periodic hard‑link dedup
    optimise.automatic = true;

    settings = {

      # Core Features
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
      ];

      # Parallel builds based on CPU
      max-jobs = "auto";

      # Use all cores per job when sensible
      cores = 0;

      # use xdg base directories for all the nix things
      use-xdg-base-directories = true;

      # build inside sandboxed environments
      # we only enable this on linux because it servirly breaks on darwin
      sandbox = pkgs.stdenv.hostPlatform.isLinux;

      # Avoid tmpfs exhaustion
      # build-dir = "/var/tmp";

      # Hard-link identical paths immediately
      auto-optimise-store = true;

      # Output / Debug
      show-trace = true; # Better error diagnostics
      log-lines = 50;

      # continue building derivations even if one fails
      # this is important for keeping a nice cache of derivations, usually because I walk away
      # from my PC when building and it would be annoying to deal with nothing saved
      keep-going = true;

      # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
      http-connections = 50;

      # Substituters (Caches)
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # Store Retention (Trade‑offs)
      # Keep derivations & outputs only if you use nix-direnv / want reproducible dev shells
      keep-derivations = true;
      keep-outputs = true;

      # Suppress dirty Git warnings
      warn-dirty = false;

      # Security / Trust
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
