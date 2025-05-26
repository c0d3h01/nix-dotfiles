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

      # Code editor
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
      blender-hip
      gimp

      # Terminal Utilities
      kitty
      neovim
      tmux
      coreutils
      fastfetch
      xclip
      curl
      wget
      tree
      tree-sitter
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
      eza
      tea
      less
      findutils
      hub
      ruby
      xdg-utils
      pciutils
      inxi
      procs
      glances
      cheat
      julia
      go
      glade
      gtk4
      gtkmm4
      glib
      nodejs
      yarn
      electron
      gdb
      gcc
      gnumake
      cmake
      ninja
      clang-tools
      pkg-config

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
