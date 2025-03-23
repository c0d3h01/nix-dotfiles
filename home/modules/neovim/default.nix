{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Use the default Neovim configuration with a few must-have plugins
    defaultEditor = true;

    # Use a pre-configured Neovim distribution
    plugins = with pkgs.vimPlugins; [
      # LazyVim provides a great pre-configured Neovim setup
      {
        plugin = lazy-nvim;
        type = "lua";
        config = '''';
      }

      # Pre-configured Neovim setup (will handle all plugins and configuration)
      {
        plugin = LazyVim;
        type = "lua";
        config = '''';
      }

      # Install tokyonight theme
      tokyonight-nvim
    ];

    # Minimal configuration to bootstrap the LazyVim setup
    extraLuaConfig = ''
      -- Bootstrap LazyVim
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- Add your additional plugins here if needed
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
