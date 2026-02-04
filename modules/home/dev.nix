{
  lib,
  pkgs,
  userConfig,
  ...
}: let
  inherit (lib) optionals;
  isWorkstation = userConfig.workstation or false;
in {
  home.packages = with pkgs;
    [
      # Core CLI/dev tools
      gitFull
      git-lfs
      git-crypt
      diffutils
      delta
      lazygit
      neovim
      bat
      tree-sitter
      eza
      fd
      ripgrep
      zoxide
      tmux
      fzf
      mise
      sapling
      watchman
      just
      jq
      yq
      gnupg
      openssh
      unzip
      zip
      file
      which
      curl
      wget
      rsync
      htop
      btop
      dust
      duf
      hyperfine
      tokei
    ]
    ++ optionals isWorkstation [
      # Compilers/build tools
      # gcc
      gnumake
      cmake
      ninja
      pkg-config
      clang
      llvm
      lld

      # Language toolchains
      python3
      python3Packages.pip
      nodejs_22
      go
      rustup

      # Containers and infra
      docker-client
      docker-compose
      kubectl
      k9s

      # Databases
      postgresql
      sqlite

      # GUI dev helpers
      insomnia
    ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      compression = true;
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
      addKeysToAgent = "yes";
    };
  };

  programs.gpg.enable = true;
}
