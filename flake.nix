{
  description = "NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    nur,
    ...
  } @ inputs: let
    # Shared args passed into every NixOS module and HM module
    specialArgs = {inherit inputs self;};

    # Common nixpkgs config reused across hosts and standalone HM
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [nur.overlays.default];
      };
  in
    # System-scoped outputs: devShells, formatter, packages, checks
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = mkPkgs system;
    in {
      devShells.default = pkgs.mkShell {
        name = "nix-dotfiles";
        nativeBuildInputs = with pkgs; [
          gnumake
          gitMinimal
          nil
          age
          (git-crypt.override {git = gitMinimal;})
          sops
          alejandra
          deadnix
          statix
          nix-output-monitor
          home-manager.packages.${system}.home-manager
        ];
      };

      formatter = pkgs.alejandra;
    })
    # Non-system-scoped outputs: nixosConfigurations, homeConfigurations
    # These are NEVER wrapped in eachSystem
    // {
      nixosConfigurations = {
        # Add new hosts here: hostname = mkNixosSystem { ... };
        c0d3h01 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            {nixpkgs = {config.allowUnfree = true; overlays = [nur.overlays.default];};}
            ./modules/nixos
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = specialArgs;
                users.c0d3h01.imports = [./modules/home];
              };
            }
          ];
        };
      };

      homeConfigurations = {
        # Standalone HM: used when NixOS is NOT the host (e.g. Ubuntu, macOS)
        # Activate with: home-manager switch --flake .#c0d3h01
        "c0d3h01" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = specialArgs;
          modules = [./modules/home];
        };
      };
    };
}
