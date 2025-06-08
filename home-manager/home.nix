{
  lib,
  pkgs,
  declarative,
  inputs,
  ...
}:

{
  imports = [
    ./gtk.nix
    ./spicetify.nix
  ];

  programs.home-manager.enable = true;
  # services.syncthing.enable = true;
  manual.manpages.enable = false;

  home = {
    username = declarative.username;
    homeDirectory = "/home/${declarative.username}";
    stateVersion = lib.trivial.release;
    enableNixpkgsReleaseCheck = false;

    packages = with pkgs.stable; [
      # Notion Enhancer With patches
      (pkgs.callPackage ./notion-app-enhanced { })

      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Code editors
      vscode-fhs
      # jetbrains.pycharm-community-bin
      # android-studio

      # Communication apps
      vesktop
      telegram-desktop
      zoom-us
      element-desktop
      signal-desktop

      # Common desktop apps
      postman
      github-desktop
      anydesk
      drawio
      electrum
      qbittorrent
      yt-dlp
      obs-studio
      libreoffice-qt6-fresh
      # blender-hip
      # gimp
      obsidian

      # Terminal Utilities
      neovim
      vim
      tmux
      coreutils
      fastfetch
      xclip
      curl
      wget
      tree
      nh
      stow
      zellij
      bat
      zoxide
      ripgrep
      fzf
      fd
      file
      bashInteractive
      lsd
      tea
      less
      findutils
      hub
      xdg-utils
      pciutils
      inxi
      procs
      glances
      cheat
      tree-sitter
      flake-checker
      sops

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
