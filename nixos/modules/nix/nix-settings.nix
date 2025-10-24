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

      # Build Performance
      max-jobs = "auto"; # Parallel builds based on CPU
      cores = 0; # Use all cores per job when sensible
      use-xdg-base-directories = true;
      sandbox = pkgs.stdenv.hostPlatform.isLinux;
      build-dir = "/var/tmp"; # Avoid tmpfs exhaustion
      auto-optimise-store = true; # Hard-link identical paths immediately
      builders-use-substitutes = true; # Remote builders (if any) may use caches

      # Output / Debug
      show-trace = true; # Better error diagnostics
      log-lines = 50;

      # Network / Fetch Tuning
      http-connections = 50; # More parallel narinfo fetches
      connect-timeout = 10;
      download-attempts = 4;

      # Substituters (Caches)
      substituters = [
        "https://nix-community.cachix.org"
        "https://chaotic-nyx.cachix.org"
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
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
