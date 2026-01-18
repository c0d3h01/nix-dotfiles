{pkgs, ...}: {
  nix.settings = {
    # Free up to 20GiB whenever there is less than 5GB left.
    # this setting is in bytes, so we multiply with 1024 by 3
    min-free = 5 * 1024 * 1024 * 1024;
    max-free = 20 * 1024 * 1024 * 1024;

    # supported system features
    system-features = [
      "nixos-test"
      "kvm"
      "recursive-nix"
      "big-parallel"
    ];

    # Core Features
    experimental-features = [
      # enables flakes, needed for this config
      "flakes"

      # enables the nix3 commands, a requirement for flakes
      "nix-command"

      # Allows Nix to automatically pick UIDs for builds, rather than creating nixbld* user accounts
      "auto-allocate-uids"
    ];

    # we don't want to track the registry, but we do want to allow the usage
    # of the `flake:` references, so we need to enable use-registries
    use-registries = true;
    flake-registry = "";

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
    log-lines = 30;

    # continue building derivations even if one fails
    # this is important for keeping a nice cache of derivations, usually because I walk away
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

    # build from source if the build fails from a binary source
    # fallback = true;

    # for direnv GC roots
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
}
