{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPackages = with pkgs; [
      # Misc tools
      ripgrep
      fd
      fzf
      tree-sitter

      # Go
      go
      gopls
      delve
      golangci-lint

      # Rust
      rust-analyzer
      rustc
      cargo
      clippy
      rustfmt

      # C/C++
      clang
      clang-tools
      cmake
      gnumake
      pkg-config
      bear
      gcc

      # PHP
      php
      phpactor
      phpPackages.phpstan

      # Ruby
      rubyPackages_3_3.ruby-lsp

      # Python
      pyright
      ruff
      black
      isort

      # Lua
      lua-language-server
      stylua

      # Nix
      nixd
      alejandra
      statix
      deadnix

      # Web basics
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      bash-language-server
    ];
  };
}
