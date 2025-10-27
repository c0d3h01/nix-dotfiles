{ lib, inputs, ... }:
{
  # Define systems to support
  systems = import inputs.systems;

  # Set up pkgs for each system
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };
  };
}

