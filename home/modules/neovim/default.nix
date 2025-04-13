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

    extraLuaConfig = ''
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "lazyvim.plugins.extras" },
        },

        defaults = {
          lazy = true,
          version = false,
        },

        install = { colorscheme = { "tokyonight" } },
        checker = { enabled = true },
        
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip",
              "matchit",
              "matchparen",
              "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';
  };
}
