{
  lib,
  pkgs,
  ...
}: {
  nix = {
    # nix alternative - modern nix version.
    # package = pkgs.lixPackageSets.stable.lix;

    # Prioritize UI responsiveness during builds.
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";

    # automatic garbage cleaner, scheduled.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # auto optimization, scheduled.
    optimise = {
      automatic = true;
      dates = "Sun 04:00";
    };

    # global nix settings.
    settings = {
      # Prevent disk full errors on small NVMe
      min-free = 1024 * 1024 * 1024;
      max-free = 5 * 1024 * 1024 * 1024;

      max-jobs = 4;
      cores = 4;

      # Store can be optimised during every build.
      auto-optimise-store = true;

      experimental-features = ["nix-command" "flakes"];

      # Network & Caches
      http-connections = 128;
      max-substitution-jobs = 128;
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
