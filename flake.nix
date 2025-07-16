{
  description = "c0d3h01's dotfiles";

  outputs =
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./modules/flake ]; };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # lix is fork of nix
    izlix = {
      type = "github";
      owner = "isabelroses";
      repo = "izlix";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix_2_18.follows = "";
        pre-commit-hooks.follows = "";
        nix2container.follows = "";
        flake-compat.follows = "";
      };
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      type = "github";
      owner = "nix-darwin";
      repo = "nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      type = "github";
      owner = "nix-community";
      repo = "NixOS-WSL";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "pull/4976/merge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    buildbot-nix = {
      url = "github:nix-community/buildbot-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Flake management
    # bring all the mess together with flake-parts
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # easily manage our hosts
    easy-hosts = {
      type = "github";
      owner = "tgirlcloud";
      repo = "easy-hosts";
      # url = "git+file:/Users/isabel/dev/easy-hosts";
    };

    ### Security stuff
    # secure-boot on nixos
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        pre-commit-hooks-nix.follows = "";
        flake-compat.follows = "";
      };
    };

    # Secrets, shhh
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Additional packages
    # a plain simple way to host a mail server
    simple-nixos-mailserver = {
      type = "gitlab";
      owner = "simple-nixos-mailserver";
      repo = "nixos-mailserver";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-25_05.follows = "";
        git-hooks.follows = "";
        flake-compat.follows = "";
        blobs.follows = "";
      };
    };

    fht-compositor = {
      type = "github";
      owner = "isabelroses"; # "nferhat";
      repo = "fht-compositor";
      ref = "cherry-picks"; # "feat-ipc";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        rust-overlay.follows = "";
        fht-share-picker.follows = "";
      };
    };

    fht-share-picker = {
      type = "github";
      owner = "nferhat";
      repo = "fht-share-picker";
      ref = "gtk-rewrite";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        rust-overlay.follows = "";
      };
    };

    homebrew = {
      type = "github";
      owner = "zhaofengli";
      repo = "nix-homebrew";
    };

    ### misc
    # declarative theme management
    catppuccin = {
      type = "github";
      owner = "catppuccin";
      repo = "nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theme like catppuccin
    evergarden = {
      type = "github";
      owner = "everviolet";
      repo = "nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### my programs
    tgirlpkgs = {
      type = "github";
      owner = "tgirlcloud";
      repo = "pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    izvim = {
      type = "github";
      owner = "isabelroses";
      repo = "nvim";

      inputs = {
        nixpkgs.follows = "";
        systems.follows = "";
      };
    };

    ivy = {
      type = "github";
      owner = "comfysage";
      repo = "ivy";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        neovim-nightly-overlay.inputs.flake-parts.follows = "flake-parts";
      };
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # transative deps
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };
  };
}
