{
  config,
  lib,
  pkgs,
  userConfig,
  inputs,
  ...
}:

{
  imports = [
    # Sops secret management for homeland
    inputs.sops-nix.homeManagerModules.sops

    ./spicetify.nix
  ];

  # services.syncthing.enable = true;

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = lib.trivial.release;
    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [

      # Secrets management tool
      age
      sops

      # Let install Home manager
      home-manager

      # Terminal Utilities
      neovim
      tmux
      coreutils
      fastfetch
      xclip
      curl
      wget
      tree
      stow
      zellij
      bat
      zoxide
      ripgrep
      fd
      file
      bashInteractive
      lsd
      tea
      less
      binutils
      findutils
      xdg-utils
      pciutils
      inxi
      procs
      glances
      cheat # CheatSheet
      tree-sitter
      # devenv
      just
      pre-commit
      fzf

      # Language Servers
      lua-language-server
      nil

      # Extractors
      unzip
      unrar
      p7zip
      xz
      zstd
      cabextract

      # git
      git
      git-lfs
      gh
      delta
      mergiraf
      lazygit
    ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.log_filter = "ignore-everything-forever";
    };
  };
}
