{pkgs, ...}: {
  home.packages = with pkgs; [
    # Core CLI/dev tools
    gitFull
    gh
    git-lfs
    git-crypt
    diffutils
    delta
    lazygit
    tree-sitter
    fd
    sapling
    watchman
    just
    icdiff
    unzip
    zip
    file
    curl
    wget
    rsync
    htop
  ];
}
