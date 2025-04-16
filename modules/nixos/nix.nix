{
  config,
  inputs,
  outputs,
  userConfig,
  lib,
  ...
}: let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in {
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfreePredicate = _: true;
      allowUnfree = true;
      tarball-ttl = 0;
      android_sdk.accept_license = true;
    };
  };

  system.stateVersion = userConfig.stateVersion;
  networking.hostName = userConfig.hostname;

  # build takes forever
  documentation.nixos.enable = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix = {
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;

    settings = {
      flake-registry = "";
      warn-dirty = false;
      show-trace = true;
      keep-going = true;
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0; # Use all available cores

      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
