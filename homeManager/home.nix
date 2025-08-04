{
  self,
  userConfig,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./modules
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    inherit (userConfig) username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = lib.trivial.release;
    shell.enableZshIntegration = true;

    packages = with pkgs; [
      # Secrets management tool
      sops

      # Terminal Utilities
      tmux
      fastfetch
      xclip
      curl
      wget
      tree
      stow
      zellij
      bat
      file
      icdiff
      tea
      less
      procs
      lsd
      fd
      ripgrep
      zoxide
      glances
      fzf
      jj # JSON Stream Editor
      cheat # CheatSheet
      bottom
      just
      tree-sitter # Parser generator tool
      gdu # Disk usage analyzer CLI
      seahorse # managing encryption keys
      starship

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
      delta
      mergiraf
    ];
  };
}
