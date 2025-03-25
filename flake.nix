{
  description = "c0d3h01 dotfiles";

  inputs = {
    # Package sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Secret Manager 
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR (Nix User Repository)
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, agenix, home-manager, nur, ... }:
    let
      # System architecture, user configurations
      system = "x86_64-linux";
      username = "c0d3h01";
      hostname = "NixOS"; # nixos-rebuild --flake .#NewHostName!
      useremail = "c0d3h01@gmail.com";

      # Shared arguments for modules
      specialArgs = {
        inherit system username hostname useremail agenix;
        inputs = self.inputs;
      };

      # Generate pkgs with custom configurations
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations.${hostname} = lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          # -*-[ System configurations, modules ]-*-
          ./nix/configuration.nix
          # ./secrets.nix
          ({ config, ... }: {
            system.stateVersion = "24.11";
            networking.hostName = hostname;
          })

          # -*-[ Home Manager integration, modules ]-*-
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${username} = import ./home/home.nix;
            };
          }

          # NUR overlay
          nur.modules.nixos.default
        ];
      };

      # DevShell
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Nix tools
          nixpkgs-fmt
          nil
          # GTK & Graphics
          pkg-config
          gtk3
        ];
        shellHook = "exec ${pkgs.zsh}/bin/zsh";
      };

      # NixFormatter
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
