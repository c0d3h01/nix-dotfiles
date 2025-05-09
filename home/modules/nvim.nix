{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      LazyVim
      lazygit-nvim
      tokyonight-nvim
      rocks-nvim
    ];

    extraPackages = with pkgs; [
      tree-sitter
      lazygit
      imagemagick
      xclip
    ];
  };
}
