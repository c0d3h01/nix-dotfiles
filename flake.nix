{
  description = "NixOS Dotfiles c0d3h01";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # System Architecture
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      defaultSystem = "x86_64-linux";
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # User Configuations
      userConfig = {
        username = "c0d3h01";
        fullName = "Harshal Sawant";
        email = "haarshalsawant@gmail.com";
        hostname = "NixOS";
        stateVersion = "24.11";
      };

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          # Unstable Nixpkgs config
          config = {
            allowUnfree = true;
            tarball-ttl = 0;
            android_sdk.accept_license = true;
          };
          overlays = [
            (final: prev: {
              # Stable Nixpkgs config
              stable = import inputs.nixpkgs-stable {
                inherit system;
                config.allowUnfree = true;
              };
            })
            # Nur for firefox extensions
            inputs.nur.overlays.default
          ];
        };

      # Special Arguments for Nix modules
      specialArgs = system: {
        inherit inputs system userConfig;
      };

      # NixOS Configuration
      mkNixOSConfiguration =
        {
          system ? defaultSystem,
          hostname ? userConfig.hostname,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs system;

          modules = [
            ./nix
            { nixpkgs.pkgs = mkPkgs system; }

            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs system;

                users.${userConfig.username} = {
                  imports = [ ./home/home.nix ];
                  home.stateVersion = userConfig.stateVersion;
                };
              };
            }
          ];
        };
    in
    {
      # ========== Outputs ==========
      nixosConfigurations.${userConfig.hostname} = mkNixOSConfiguration { };

      devShells = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          default = pkgs.mkShell {
            packages = with nixpkgs; [
              pkg-config
              gtk3
            ];
            shellHook = "exec zsh";
          };
        }
      );

      checks = forAllSystems (
        system:
        inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        }
      );

      formatter = forAllSystems (system: (mkPkgs system).nixfmt-tree);
    };
}
