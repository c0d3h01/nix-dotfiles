{
  description = "NixOS Dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";

    spicetify.url = "github:Gerg-L/spicetify-nix";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    llm-agents.url = "github:numtide/llm-agents.nix";
    llm-agents.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = lib.genAttrs supportedSystems;
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    mkHost = import ./lib/mkHost.nix {inherit inputs self;};

    hosts = {
      laptop = mkHost {
        hostname = "laptop";
        username = "c0d3h01";
        fullName = "Harshal Sawant";
        system = "x86_64-linux";
        isNixOS = true;
        bootloader = "grub";
        windowManager = "gnome";
        workstation = true;
        stateVersion = "25.11";
        nixosModules = [./hosts/laptop];
      };
    };

    fmtFor = system:
      import ./lib/formatter.nix {
        pkgs = pkgsFor system;
        inherit self;
      };
  in {
    nixosConfigurations = lib.mapAttrs (_: h: h.nixos) hosts;

    homeConfigurations =
      lib.mapAttrs' (
        name: h:
          lib.nameValuePair "${h.meta.username}@${name}" h.home
      )
      hosts;

    overlays = import ./overlays {inherit inputs;};

    devShells = forAllSystems (system: {
      default = import ./lib/shell.nix {
        pkgs = pkgsFor system;
        inherit ((fmtFor system)) formatter;
      };
    });

    formatter = forAllSystems (system: (fmtFor system).formatter);

    checks = forAllSystems (system: {
      formatting = (fmtFor system).check;
    });

    packages = forAllSystems (system: import ./lib/scripts.nix {pkgs = pkgsFor system;});
  };
}
