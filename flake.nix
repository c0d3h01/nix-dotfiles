{
  description = "c0d3h01 dotfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixcord.url = "github:kaylorben/nixcord";
    stylix.url = "github:danth/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , agenix
    , home-manager
    , nur
    , ...
    }@inputs:
    let
      # System, User configurations
      system = "x86_64-linux";
      username = "c0d3h01";
      hostname = "NixOS";
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
          ./nix
          ./secrets.nix
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops

          ({ config, ... }: {
            system.stateVersion = "24.11";
            networking.hostName = hostname;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.${username} = import ./home/home.nix;
            };
          }
          nur.modules.nixos.default
        ];
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          pkg-config
          gtk3
        ];
        shellHook = "exec ${pkgs.zsh}/bin/zsh";
      };
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
