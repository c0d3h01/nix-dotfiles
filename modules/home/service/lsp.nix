{pkgs, ...}: {
  home.packages = with pkgs; [
    # Nix
    nil
    nixd

    # Shells
    bash-language-server

    # Web
    typescript-language-server
    vscode-langservers-extracted
    eslint
    html-tidy

    # Python
    pyright

    # Go/C/C++
    gopls
    clang-tools

    # Lua
    lua-language-server

    # YAML/TOML/JSON
    yaml-language-server
    taplo

    # Docker/Infra
    dockerfile-language-server
    terraform-ls

    # Markdown
    marksman

    # SQL
    sqls
  ];
}
