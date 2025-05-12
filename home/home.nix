{
  pkgs,
  userConfig,
  ...
}:

{
  imports = [
    ./modules
  ];

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = userConfig.stateVersion;

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      BROWSER = "firefox";
      PAGER = "less";
      LESS = "-R";
    };

    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    packages = with pkgs; [
      # Terminal
      kitty
      tree-sitter

      # Utilities
      tmux
      coreutils
      fastfetch
      glances
      xclip
      curl
      wget
      tree
      asar
      fuse
      nh # Nix Garbage Cleaner
      stow
      zellij

      # Editors & Viewers
      fd # find
      file

      # Nix Tools
      nix-prefetch-github

      # Language Servers
      lua-language-server
      nil

      # System Monitoring
      inxi
      procs

      # Extractors
      unzip
      unrar
      p7zip
      xz
      zstd
      cabextract
    ];
  };
}
