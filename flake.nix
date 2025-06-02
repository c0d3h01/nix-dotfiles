{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    systems.url = "github:nix-systems/default";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "github:/ghostty-org/ghostty";
    ghostty.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.inputs.flake-utils.follows = "flake-utils";
    ghostty.inputs.flake-compat.follows = "";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-utils,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # User Configuations
      userConfig = {
        username = "c0d3h01";
        fullName = "Harshal Sawant";
        hostname = "NixOS";
      };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        };
      });

      # NixOS configuration with home-manager.
      nixosConfigurations.${userConfig.hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs outputs userConfig; };
        modules = [
          ./machines/c0d3h01
          inputs.disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          # inputs.nixos-hardware.nixosModules.dell-inspiron-14-5420

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs outputs userConfig; };
              users.${userConfig.username} = {
                imports = [
                  ./home-manager/home.nix
                ];
              };
            };
          }
        ];
      };

      # Standalone home-manager configuration
      homeConfigurations = {
        "${userConfig.username}@${userConfig.hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs userConfig; };
          modules = [
            ./home-manager/home.nix
            { nixpkgs.config.allowUnfree = true; }
          ];
        };
      };
    };
}
