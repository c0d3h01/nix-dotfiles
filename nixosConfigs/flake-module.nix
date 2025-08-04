{ inputs, ... }:
let
  hosts = import ../systems/config.nix;

  # Function to create a NixOS configuration for a host
  mkNixosSystem =
    hostName: userConfig:
    inputs.nixpkgs.lib.nixosSystem {
      inherit (userConfig) system;
      specialArgs = {
        inherit inputs userConfig hostName;
        inherit (inputs) self;
      };
      modules = [
        # Import all NixOS modules
        ./modules
        ../systems

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
              inherit inputs userConfig hostName;
              inherit (inputs) self;
              inherit (inputs) nixgl;
            };
            users.${userConfig.username} = {
              imports = [ ../homeManager/home.nix ];
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
