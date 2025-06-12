{
  description = "NixOS Flake: workspace";

  inputs = {
    # Use stable as the default nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    systems.url = "github:nix-systems/default";
    flake-utils.inputs.systems.follows = "systems";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Host-specific modules
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin.url = "github:catppuccin/nix";
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
        config = {
          allowUnfree = true;
          allowBroken = false;
          allowUnsupportedSystem = false;
        };
        overlays = overlays;
      };

      machineModule = name: ./machines/${name};
      homeModule = ./home-manager/home.nix;

      # Modular devshells import
      devShellModules = {
        python = ./devShells/python.nix;
        rust = ./devShells/rust.nix;
        node = ./devShells/node.nix;
        go = ./devShells/go.nix;
        java = ./devShells/java.nix;
      };

      # Modular devenv shells import
      devenvShellModules = {
        rust = ./devenvShells/rust.nix;
        flutter = ./devenvShells/flutter.nix;
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

        devShells = builtins.mapAttrs (name: file: import file { inherit pkgs; }) devShellModules;
        devenvShells = builtins.mapAttrs (name: file: import file { pkgs = pkgs; inputs = inputs; }) devenvShellModules;

        homeConfigurations."${declarative.username}@${declarative.hostname}" =
          home-manager.lib.homeManagerConfiguration
            {
              pkgs = pkgs;
              extraSpecialArgs = {
                inherit inputs self declarative;
              };
              modules = [ homeModule ];
            };
      }
    )
    // {
      nixosConfigurations.${declarative.hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs self declarative;
        };
        modules = [
          (machineModule declarative.username)
          inputs.disko.nixosModules.disko
          (
            { config, ... }:
            {
              nixpkgs = nixpkgsConfig;
            }
          )
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs self declarative;
              };
              users.${declarative.username} = {
                imports = [ homeModule ];
              };
            };
          }
        ];
      };
    };
}
