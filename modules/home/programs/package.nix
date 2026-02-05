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
      gh
      git-lfs
      git-crypt
      diffutils
      delta
      lazygit
      tree-sitter
      fd
      mise
      sapling
      watchman
      just
      jq
      yq
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
}
