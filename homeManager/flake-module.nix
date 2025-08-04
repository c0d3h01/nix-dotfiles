{ inputs, ... }:
let
  hosts = import ../systems/config.nix;

  # Function to create a Home Manager configuration for a host
  mkHomeConfiguration =
    hostName: userConfig:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit (userConfig) system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit inputs userConfig hostName;
        inherit (inputs) self;
        inherit (inputs) nixgl;
      };
      modules = [
        ./home.nix
        ../systems
      ];
    };

  # Generate homeConfigurations for all hosts
  homeConfigurations = inputs.nixpkgs.lib.mapAttrs (
    hostName: userConfig: mkHomeConfiguration hostName userConfig
  ) hosts;

  # Also create user@host format for compatibility
  homeConfigurationsWithUser = inputs.nixpkgs.lib.mapAttrs' (
    hostName: userConfig:
    inputs.nixpkgs.lib.nameValuePair "${userConfig.username}@${userConfig.hostname}" (
      mkHomeConfiguration hostName userConfig
    )
  ) hosts;
in
{
  flake.homeConfigurations = homeConfigurations // homeConfigurationsWithUser;
}
