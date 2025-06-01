{
  lib,
  pkgs,
  userConfig,
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
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = lib.trivial.release;
    enableNixpkgsReleaseCheck = false;

    sessionVariables = {
      EDITOR = "micro";
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    packages = with pkgs; [
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

      # Terminal Utilities
      neovim
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

    zellij = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;

      settings = {
        theme = "one-half-dark";
        themes.one-half-dark = {
          bg = [
            40
            44
            52
          ];
          gray = [
            40
            44
            52
          ];
          red = [
            227
            63
            76
          ];
          green = [
            152
            195
            121
          ];
          yellow = [
            229
            192
            123
          ];
          blue = [
            97
            175
            239
          ];
          magenta = [
            198
            120
            221
          ];
          orange = [
            216
            133
            76
          ];
          fg = [
            220
            223
            228
          ];
          cyan = [
            86
            182
            194
          ];
          black = [
            27
            29
            35
          ];
          white = [
            233
            225
            254
          ];
        };
      };
    };
  };
}
