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

  # home.file.".modules/shell/.zshrc".source = ./modules/zsh/.zshrc;

  # Core configuration for $home
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
    PAGER = "less";
    LESS = "-R";
    PKG_CONFIG_PATH = "${pkgs.gtk3}/lib/pkgconfig:$PKG_CONFIG_PATH";
  };

  # -*-[ Home Packages ]-*-
  home.packages = with pkgs; [

    # -*-[ Let install Home-manager ]-*-
    home-manager

    # -*-[ Utilities ]-*-
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

    # -*-[ Editors & Viewers ]-*-
    eza # ls
    bat # cat
    fd # find
    ripgrep # Better than grep
    dust # Disk usage visualization

    # -*-[ Rust Tooling ]-*-
    cargo
    rustc
    rust-analyzer

    # -*-[ Git Tools ]-*-
    git
    git-lfs
    gh # GitHub CLI
    gitui # Terminal UI for git

    # -*-[ Nix Tools ]-*-
    nix-output-monitor # Monitor nix-build progress
    nix-prefetch-github

    # -*-[ Language Servers ]-*-
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    lua-language-server
    nil

    # -*-[ System Monitoring ]-*-
    inxi
    procs

    # -*-[ Diffing ]-*-
    diff-so-fancy
  ];

  # XDG Base Directory specification
  xdg = {
    enable = true;

    # Define standard directories
    userDirs = {
      enable = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      templates = "$HOME/Templates";
      publicShare = "$HOME/Public";
    };
  };
}
