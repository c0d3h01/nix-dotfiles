{
  userConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # Function to recursively import modules from a directory
  # It takes a path and returns a list of modules.
  # It excludes files/directories starting with an underscore.
  autoImportModules =
    dir:
    let
      # Read the contents of the directory
      contents = builtins.readDir dir;

      # Filter out files/directories that start with '_'
      filteredContents = lib.attrsets.filterAttrs (
        name: type: !(lib.strings.hasPrefix "_" name)
      ) contents;

      # Process each item
      modules = lib.attrsets.mapAttrsToList (
        name: type:
        let
          path = "${dir}/${name}";
        in
        if type == "directory" then
          # If it's a directory, recursively import modules from it
          autoImportModules path
        else if type == "regular" && lib.strings.hasSuffix ".nix" name then
          # If it's a .nix file, import it as a module
          import path
        else
          # Ignore other file types
          null
      ) filteredContents;
    in
    # Flatten the list of modules (since directories return a list of modules)
    lib.lists.flatten (lib.lists.filter (x: x != null) modules);

  # Define the path to your Home Manager modules directory!
  homeManagerModulesPath = ./modules;

in
{
  imports =
    # Sops secret management for homeland
    [
      inputs.sops-nix.homeManagerModules.sops
      ../secrets
    ]

    # Automatically import all modules from homeManager/modules ;)
    ++ (autoImportModules homeManagerModulesPath);

  # services.syncthing.enable = true;

  home = {
    username = userConfig.username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = lib.trivial.release;
    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [

      # Secrets management tool
      age
      sops

      # Let install Home manager
      home-manager

      # Terminal Utilities
      neovim
      tmux
      coreutils
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
      bashInteractive
      lsd
      tea
      less
      binutils
      findutils
      xdg-utils
      pciutils
      inxi
      procs
      glances
      cheat # CheatSheet
      tree-sitter
      # devenv
      just
      pre-commit
      fzf
      claude-code

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
