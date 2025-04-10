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
    { self
    , nixpkgs
    , home-manager
    , agenix
    , ...
    } @ inputs:
    let
      # System Architecture
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      defaultSystem = "x86_64-linux";
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # User Configuations
      userConfig = {
        username = "c0d3h01";
        fullName = "Harshal Sawant";
        email = "c0d3h01@gmail.com";
        hostname = "NixOS";
        stateVersion = "24.11";
      };

      pkgsFor = system: import nixpkgs {
        inherit system;
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
           inputs.nur.overlays.default
        ];
      };

      # Special Arguments for NixOS modules
      specialArgs = system: {
        inherit inputs system agenix;
        user = userConfig;
      };

      # NixOS Configuration
      mkNixOSConfiguration = { system ? defaultSystem, hostname ? userConfig.hostname }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs system;

          modules = [
            {
              nixpkgs.pkgs = pkgsFor system;
            }

            # Host-specific configuration
            ./hosts/${userConfig.username}

            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs system;

                users.${userConfig.username} = {
                  imports = [ ./home ];
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

      devShells = forAllSystems (system:
      let
        pkgs = pkgsFor system;
      in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              pkg-config
              gtk3
            ];
            shellHook = "exec zsh";
          };

          ci = pkgs.mkShell {
            packages = with pkgs; [
              nixpkgs-fmt
              statix
              deadnix
            ];
          };
        });

      checks = forAllSystems (system:
        inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
          };
        });

      formatter = forAllSystems (system: (pkgsFor system).nixpkgs-fmt);
    };
}