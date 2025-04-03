{
  description = "NixOS configuration for c0d3h01";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      user = {
        username = "c0d3h01";
        fullName = "Harshal Sawant";
        email = "c0d3h01@gmail.com";
        hostname = "NixOS";
        stateVersion = "24.11";
      };

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Create package set with overlays for each system
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      };

      # Shared arguments for all modules
      commonArgs = system: {
        inherit inputs user;
        pkgs = pkgsFor system;
        lib = nixpkgs.lib;
      };
    in
    {
      # Main NixOS system configuration
      nixosConfigurations.${user.hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = commonArgs "x86_64-linux";
        modules = [
          ./hosts/${user.hostname}
          inputs.spicetify-nix.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.nur.modules.nixos.default

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = commonArgs "x86_64-linux";
              users.${user.username} = {
                imports = [ ./home ];
                home.stateVersion = user.stateVersion;
              };
            };
          }
        ];
      };

      # Development and CI environments
      devShells = forAllSystems (system:
        let pkgs = pkgsFor system; in {
          default = pkgs.mkShell {
            packages = with pkgs; [ pkg-config gtk3 ];
            shellHook = "exec zsh";
          };

          ci = pkgs.mkShell {
            packages = with pkgs; [ nixpkgs-fmt statix deadnix ];
          };
        });

      # Formatting and linting configuration
      formatter = forAllSystems (system: (pkgsFor system).nixpkgs-fmt);
    };
}