{pkgs, ...}: {
  home.packages = with pkgs; [
    gitFull
    git-lfs
    git-crypt
    diffutils
    delta
    gh
    lazygit
    neovim
    bat
    starship
    tree-sitter
    eza
    fd
    ripgrep
    zoxide
    tmux
    fzf
    mise
    sapling
    watchman
    gemini-cli
  ];
}
