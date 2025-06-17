{
  description = "NixOS Flake: WorkSpace";

  inputs = {
    # System module inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    systems.url = "github:nix-systems/default";
    flake-utils.inputs.systems.follows = "systems";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Extras / Modules
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    catppuccin.url = "github:c0d3h01/catppuccin-nix/main";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      ...
    }:
    let
      declarative = {
        hostname = "devbox";
        username = "c0d3h01";
        fullName = "Harshal Sawant";
      };

      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      overlays = import ./overlays;

      nixpkgsConfig = {
        config.allowUnfree = true;
        overlays = overlays;
      };

      machineModule = name: ./machines/${name};
      homeModule = ./homeManager/home.nix;

      devShellModules = {
        python = ./devShells/python.nix;
        rust = ./devShells/rust.nix;
        node = ./devShells/node.nix;
        go = ./devShells/go.nix;
        java = ./devShells/java.nix;
      };

      devenvShellModules = {
        rust = ./devenvShells/rust.nix;
        flutter = ./devenvShells/flutter.nix;
      };

      homeConfigurations = {
        "${declarative.username}@${declarative.hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = overlays;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs self declarative;
          };
          modules = [ homeModule ];
        };
      };

    in

    flake-utils.lib.eachSystem allSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; } // nixpkgsConfig;
      in
      {
        pkgs = pkgs;
        formatter = pkgs.nixfmt-tree;
        checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };

        devShells = builtins.mapAttrs (_: file: import file { inherit pkgs; }) devShellModules;
        devenvShells = builtins.mapAttrs (
          _: file:
          import file {
            pkgs = pkgs;
            inputs = inputs;
          }
        ) devenvShellModules;
      }
    )
    // {
      inherit homeConfigurations;

      nixosConfigurations.${declarative.hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs self declarative;
        };
        modules = [
          (machineModule declarative.username)
          inputs.disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs self declarative;
            };
            home-manager.users.${declarative.username} = {
              imports = [ homeModule ];
            };
          }
        ];
      };
    };
}
