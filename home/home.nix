{ pkgs, username, ... }:
{
  imports = [
    ./modules
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  home.stateVersion = "24.11";

  # Enable firefox coustom modules
  modules.firefox.enable = true;

  # home.file.".modules/zshell/.zshrc".source = ./modules/zsh/.zshrc;

  # Core configuration for $home
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
    PAGER = "less";
    LESS = "-R";
  };

  # -*-[ Home Packages ]-*-
  home.packages = with pkgs; [
    # Let install Home-manager
    home-manager

    # Utilities
    fastfetch
    glances
    tmux
    xclip
    curl
    wget
    tree
    asar
    fuse
    dos2unix
    zoxide
    android-tools # Android
    appimage-run
    universal-android-debloater # uad-ng
    wine # Windows
    ventoy
    shc # Shell compiler
    nh # Nix Garbage Cleaner
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    age
    gnupg

    # Editors & Viewers
    eza # ls
    bat # cat
    fd # find
    ripgrep # Better than grep
    dust # Disk usage visualization

    # Git Tools
    git
    git-lfs
    gh # GitHub CLI
    gitui # Terminal UI for git

    # Nix Tools
    nix-prefetch-github

    # Language Servers
    lua-language-server
    nil

    # System Monitoring
    inxi
    procs

    # Diffing
    diff-so-fancy
  ];

  # XDG Base
  xdg = {
    enable = true;
    userDirs.enable = true;
  };
}
