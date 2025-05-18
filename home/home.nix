{
  pkgs,
  userConfig,
  ...
}:

{
  imports = [
    ./modules
    ./tools
  ];

  programs.home-manager.enable = true;
  services.syncthing.enable = true;

  myModules = {
    androidTools = true;
    # hackerMode = true;
    # pythonTools = true;
    # rustTools = true;
  };

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = userConfig.stateVersion;
    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [
      # Notion Enhancer With patches
      (pkgs.callPackage ./modules/notion-app-enhanced { })

      # Code editor
      vscode-fhs

      # Development desktop apps
      postman
      github-desktop

      # Communication apps
      vesktop
      telegram-desktop
      zoom-us
      element-desktop

      # Common desktop apps
      anydesk
      drawio
      electrum

      # Terminal
      kitty
      neovim

      # Utilities
      tmux
      coreutils
      fastfetch
      xclip
      curl
      wget
      tree
      asar
      fuse
      nh
      stow
      zellij
      bat
      direnv
      zoxide
      eza
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
      ruby
      xdg-utils

      # Nix Tools
      nix-prefetch-github

      # Language Servers
      lua-language-server
      nil

      # System Monitoring
      inxi
      procs
      glances
      htop

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
}
