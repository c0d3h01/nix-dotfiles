{
  pkgs,
  lib,
  userConfig,
  ...
}:
let
  inherit (lib) mkDefault optionals;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      # Appearance
      catppuccin-nvim
      lualine-nvim
      indent-blankline-nvim
      nvim-web-devicons
      bufferline-nvim
      gitsigns-nvim

      # Navigation
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim

      # LSP & Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      luasnip
      cmp_luasnip
      lspkind-nvim

      # Utilities
      nvim-autopairs
      nvim-comment
      which-key-nvim
      toggleterm-nvim
      alpha-nvim
    ];

    extraConfig = ''
      " Set theme
      colorscheme catppuccin-mocha

      " Set hybrid line numbers
      set number relativenumber

      " Enable mouse support
      set mouse=a

      " Enable clipboard
      set clipboard+=unnamedplus

      " Set indentation
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set smartindent
    '';

    extraLuaConfig = ''
      -- Set up LSP
      local lspconfig = require('lspconfig')
      lspconfig.nil_ls.setup {}
      lspconfig.nixd.setup {}

      -- Set up telescope
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          file_ignore_patterns = { "%.git", "node_modules", ".cache" }
        }
      }

      -- Set up treesitter
      require('nvim-tree').setup()
      require('bufferline').setup()
    '';
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}


