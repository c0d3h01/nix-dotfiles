{
  lib,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.lix;

    # Prioritize UI responsiveness during builds
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = "Sun 04:00";
    };

    settings = {
      # Prevent disk full errors on small NVMe
      min-free = 1024 * 1024 * 1024;
      max-free = 5 * 1024 * 1024 * 1024;

      # Critical for 6GB RAM: Limit parallel builds to prevent OOM
      max-jobs = 2;
      cores = 2;
      auto-allocate-uids = true;

      experimental-features = ["nix-command" "flakes" "auto-allocate-uids"];

      # Network & Caches
      http-connections = 25;
      builders-use-substitutes = true;

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-users = ["root" "@wheel"];
    };
  };
}
