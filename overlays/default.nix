{ inputs }:

[
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      system = prev.stdenv.system;
      config.allowUnfree = true;
    };
  })
]
