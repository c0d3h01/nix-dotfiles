{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      tree-sitter

      # # LSP servers
      # lua-language-server
      # nil
      # bash-language-server
      # pyright
      # typescript-language-server
      # nodePackages.typescript
      # vscode-langservers-extracted
      # gopls
      # rust-analyzer
      # zls
      # clang-tools
      # jdt-language-server
      # omnisharp-roslyn
      # phpactor
      # rubyPackages.solargraph
      # dockerfile-language-server
      # yaml-language-server
      # taplo

      # Debug adapters
      delve
      lldb
      netcoredbg
      python3Packages.debugpy
      vscode-js-debug

      # Notebook tooling
      python3Packages.jupytext
    ];

    plugins = with pkgs.vimPlugins; [
      # Theme
      tokyonight-nvim

      # UI
      lualine-nvim
      nvim-web-devicons
      which-key-nvim
      fidget-nvim
      nvim-notify
      neo-tree-nvim
      nui-nvim
      bufferline-nvim
      nvim-navic
      barbecue-nvim
      dressing-nvim
      nvim-colorizer-lua
      vim-illuminate
      aerial-nvim
      trouble-nvim
      todo-comments-nvim
      toggleterm-nvim
      conform-nvim

      # LSP + completion
      nvim-lspconfig
      neodev-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      lspkind-nvim
      luasnip
      cmp_luasnip
      friendly-snippets

      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.c
        p.cpp
        p.c_sharp
        p.css
        p.dockerfile
        p.go
        p.html
        p.java
        p.javascript
        p.json
        p.lua
        p.markdown
        p.markdown_inline
        p.nix
        p.php
        p.python
        p.regex
        p.rust
        p.ruby
        p.toml
        p.typescript
        p.vim
        p.vimdoc
        p.yaml
        p.zig
      ]))
      nvim-treesitter-textobjects

      # Tools
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      project-nvim
      gitsigns-nvim
      comment-nvim
      nvim-surround
      nvim-autopairs
      indent-blankline-nvim
      oil-nvim
      nvim-spectre

      # Debugging
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-dap-python
      nvim-dap-go
      nvim-dap-vscode-js
    ];

    initLua = builtins.readFile ./init.lua;
  };
}
