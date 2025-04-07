{
  description = "NixOS Dotfiles c0d3h01";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs =
    { self
    , nixpkgs-stable
    , nixpkgs-unstable
    , home-manager
    , agenix
    , ...
    } @ inputs:
    let
      # System Architecture
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      defaultSystem = "x86_64-linux";

      # User Configuations
      userConfig = {
        username = "c0d3h01";
        fullName = "Harshal Sawant";
        email = "c0d3h01@gmail.com";
        hostname = "NixOS";
        stateVersion = "24.11";
      };

      # Helper Functions
      forAllSystems = nixpkgs-stable.lib.genAttrs supportedSystems;

      mkPkgs = system: import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
          tarball-ttl = 0;
          android_sdk.accept_license = true;
        };

        overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
          inputs.nur.overlays.default
        ];
      };

      mkSpecialArgs = system: {
        inherit inputs system agenix;
        user = userConfig;
        pkgs = mkPkgs system;
      };

      # NixOS Configuration
      mkNixOSConfiguration = { system ? defaultSystem, hostname ? userConfig.hostname }:
        nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = mkSpecialArgs system;

          modules = [
            # Host-specific configuration
            ./hosts/${userConfig.username}

            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = mkSpecialArgs system;

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
          pkgs = mkPkgs system;
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              pkg-config
              gtk3
            ];
            shellHook = "exec zsh";
          };
        });

      # checks = forAllSystems (system: {
      #   formatting = mkPkgs system.runCommand "check-formatting" {
      #     nativeBuildInputs = [ (mkPkgs system).nixpkgs-fmt ];
      #   } ''
      #     nixpkgs-fmt --check ${./.}
      #     touch $out
      #   '';
      # });

      formatter = forAllSystems (system: (mkPkgs system).nixpkgs-fmt);
    };
}
