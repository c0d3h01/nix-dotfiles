{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  overlays = [
    (final: prev: {
      xorg = prev.xorg // {
        lndir = prev.lndir;
      };
    })
    inputs.nix-openclaw.overlays.default
  ];
in {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system overlays;
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };
  };

  flake.overlays.default = final: prev:
    lib.foldl' (acc: overlay: lib.recursiveUpdate acc (overlay final prev)) {} overlays;
}
