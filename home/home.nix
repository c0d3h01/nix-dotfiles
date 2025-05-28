{
  pkgs,
  userConfig,
  ...
}:

{
  imports = [
    ./modules
  ];

  programs.home-manager.enable = true;
  # services.syncthing.enable = true;

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = userConfig.stateVersion;
    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [
      # Notion Enhancer With patches
      (pkgs.callPackage ./modules/notion-app-enhanced { })

      # Code editors
      vscode-fhs
      jetbrains.pycharm-community-bin
      android-studio

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
      blender-hip
      gimp

      # Terminal Utilities
      kitty
      neovim
      tmux
      nix-direnv
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
}
