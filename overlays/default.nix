{
  config,
  system,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  nixpkgs.overlays = [
    inputs.hyprpanel.overlay
    (final: prev: {
      # Stable Nixpkgs config
      stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    })

    # (import ./overlay3)
  ];
}
