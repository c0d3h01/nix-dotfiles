{
  lib,
  inputs,
  pkgs,
  ...
}: {
  nix = {
    # package = inputs.lix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    package = pkgs.lixPackageSets.stable.lix;

    channel.enable = lib.mkDefault true;

    daemonCPUSchedPolicy = lib.mkDefault "batch";
    daemonIOSchedClass = lib.mkDefault "idle";

    gc = {
      automatic = true;
      dates = "daily";
      randomizedDelaySec = "45min";
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = "Sun 04:00";
      randomizedDelaySec = "30min";
    };

    settings = {
      min-free = 1024 * 1024 * 1024;
      max-free = 5 * 1024 * 1024 * 1024;

      build-dir = "/var/tmp/nix";

      auto-optimise-store = false;

      max-jobs = 2;
      cores = 2;

      system-features = ["nixos-test" "kvm" "recursive-nix"];
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids"];

      accept-flake-config = true;

      use-registries = true;
      use-xdg-base-directories = true;

      sandbox = pkgs.stdenv.hostPlatform.isLinux;

      show-trace = true;
      log-lines = 30;
      keep-going = false;
      warn-dirty = false;

      http-connections = 25;
      connect-timeout = 10;
      download-attempts = 3;

      builders-use-substitutes = true;

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      require-sigs = true;

      keep-derivations = true;
      keep-outputs = true;

      allowed-users = ["root" "@wheel"];
      trusted-users = ["root" "@wheel"];
    };
  };
}
