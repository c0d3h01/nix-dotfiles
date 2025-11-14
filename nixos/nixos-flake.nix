{
  inputs,
  self,
  config,
  ...
}:
let
  hosts = import (self + /hosts/config.nix);
  mkNixosSystem =
    hostName: userConfig:
    inputs.nixpkgs.lib.nixosSystem {
      inherit (userConfig) system;
      specialArgs = {
        inherit
          self
          inputs
          userConfig
          hostName
          ;
      };
      modules = [
        # Import modules
        (self + /nixos/modules)
        (self + /hosts)

        # Disko integration for disk partitioning
        inputs.disko.nixosModules.disko

        # Home Manager integration
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = {
              inherit
                self
                inputs
                userConfig
                hostName
                ;
            };
            users.${userConfig.username} = {
              imports = [ (self + /home-manager/modules/home.nix) ];
            };
          };
        }
      ];
    };

  # Generate nixosConfigurations for all hosts
  nixosConfigurations = inputs.nixpkgs.lib.mapAttrs mkNixosSystem hosts;
in
{
  flake = { inherit nixosConfigurations; };
}
