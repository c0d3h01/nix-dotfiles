{
  userConfig,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./cli
    ./environment
    ./programs
    ./services
    ./system
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Custom modulor programs.
  programs = {
    # hm-env.enable = true;
    hm-glApps.enable = true;
    hm-wezterm.enable = true;
    # hm-alacritty.enable = true;
    # hm-ghostty.enable = true;
    hm-notion-app.enable = true;
    hm-chromium.enable = true;
    # hm-vscode.enable = true;
    # hm-monitoring.enable = true;
    # hm-fonts.enable = true;
    hm-gnomeshell.enable = true;
    hm-gtk.enable = true;
    hm-nh.enable = true;
  };

  home = {
    inherit (userConfig) username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = lib.trivial.release;
    shell.enableZshIntegration = true;

    packages = with pkgs; [
      # Secrets management tool
      sops

      # Terminal Utilities
      rlwrap # Readline wrapper for cli programs
      libgcc
      armadillo # C++ linear algebra library
      blitz # Array library for C++
      appvm # Nix based app-vm
      neovim # EDITOR
      mpi
      tmux
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
      bash
      bashInteractive
      lsd
      tea
      less
      procs
      glances
      cheat # CheatSheet
      bottom
      just
      just-formatter
      fzf # fuzzy finder CLI
      tree-sitter # Parser generator tool
      gdu # Disk usage analyzer CLI
      seahorse # managing encryption keys

      # Language Servers
      lua-language-server
      nil
      just-lsp

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
