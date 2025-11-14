{
  inputs,
  config,
  lib,
  self,
  ...
}:
let
  hosts = import (self + /hosts/config.nix);
  mkHomeConfiguration =
    hostName: userConfig:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit (userConfig) system;
        config.allowUnfree = true;
      };

      extraSpecialArgs = {
        inherit
          userConfig
          hostName
          inputs
          self
          ;
      };
      modules = [ (self + /home-manager/modules/home.nix) ];
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
