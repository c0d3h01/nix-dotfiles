{
  lib,
  inputs,
  pkgs,
  ...
}: {
  nix = {
    channel.enable = lib.mkDefault false;

    # Pin flake inputs into the registry so `nix shell nixpkgs#...` works
    registry = lib.mapAttrs (_: flake: {inherit flake;}) inputs;

    # Keep legacy `<nixpkgs>` lookups pinned to the flake input
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    # Run nix-daemon builds at batch priority so interactive desktop stays snappy
    daemonCPUSchedPolicy = lib.mkDefault "batch";
    daemonIOSchedClass = lib.mkDefault "idle";

    settings = {
      # ── Store maintenance ──────────────────────────────────────────────
      # Free up to 5 GiB when less than 1 GiB remains on the volume.
      # Previous values (5 GiB / 20 GiB) were unrealistic for a 256 GB NVMe.
      min-free = 1024 * 1024 * 1024; # 1 GiB
      max-free = 5 * 1024 * 1024 * 1024; # 5 GiB

      # Hard-link identical store paths immediately
      auto-optimise-store = true;

      # ── Build parallelism (tuned for 4c/8t, 6 GB RAM) ─────────────────
      # 4 jobs × 2 cores = 8 threads = full utilisation without over-commit.
      # `cores = 0` (unlimited) caused OOM on heavy C++ builds.
      max-jobs = 4;
      cores = 2;

      # ── System features ────────────────────────────────────────────────
      system-features = [
        "nixos-test"
        "kvm"
        "recursive-nix"
      ];

      # ── Flake features ─────────────────────────────────────────────────
      experimental-features = [
        "flakes"
        "nix-command"
        "auto-allocate-uids"
      ];

      # Don't track the global registry, but allow flake: refs
      accept-flake-config = false;
      use-registries = true;
      flake-registry = "";

      # ── XDG / Sandbox ──────────────────────────────────────────────────
      use-xdg-base-directories = true;
      sandbox = pkgs.stdenv.hostPlatform.isLinux;

      # ── Diagnostics ────────────────────────────────────────────────────
      show-trace = true;
      log-lines = 30;
      keep-going = true;
      warn-dirty = false;

      # ── Fetch resilience ───────────────────────────────────────────────
      http-connections = 25;
      connect-timeout = 10;
      download-attempts = 3;

      # ── Substituters ───────────────────────────────────────────────────
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

      # ── Direnv / devshell GC roots ─────────────────────────────────────
      keep-derivations = true;
      keep-outputs = true;

      # ── Security / Trust ───────────────────────────────────────────────
      allowed-users = ["root" "@wheel"];
      trusted-users = ["root" "@wheel"];
    };
  };
}
