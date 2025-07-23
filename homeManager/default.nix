{
  config,
  username,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.lib.nixGL) wrap;
in
{
  imports = [
    ./modules
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.custom.glApps.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = lib.trivial.release;

    packages = with pkgs; [
      # Secrets management tool
      sops

      # Terminal Utilities
      rlwrap # Readline wrapper for cli programs
      libgcc
      armadillo # C++ linear algebra library
      blitz # Array library for C++
      appvm # Nix based app-vm
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
