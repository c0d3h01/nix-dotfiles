{
  config,
  lib,
  userConfig,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  isWorkstation = userConfig.workstation or false;

  configDirs =
    {
      "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
      "shell".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/shell";
      "cargo".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/cargo";
      "gdb".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/gdb";
      "lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/lazygit";
      "bat".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/bat";
      "fzf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/fzf";
      "lsd".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/lsd";
      "ripgrep".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/ripgrep";
      "nushell".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nushell";
      "yt-dlp".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/yt-dlp";
      "nix".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nix";
      "nixpkgs".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nixpkgs";
      "pacman".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/pacman";
      "flake8".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/flake8";
      "isort.cfg".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/isort.cfg";
    }
    // lib.optionalAttrs isWorkstation {
      "alacritty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/alacritty";
      "kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/kitty";
      "ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/ghostty";
      "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/wezterm";
      "VSCodium/User".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/VSCodium/User";
      "chrome-flags.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/chrome-flags.conf";
      "chromium-flags.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/chromium-flags.conf";
    };

  rootFiles =
    {
      ".gdbinit".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gdbinit";
      ".dircolors".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.dircolors";
      ".zprofile".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.zprofile";
      ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gitconfig";
      ".gitignore".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gitignore";
      ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gitignore_global";
      ".gitattributes".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.gitattributes";
    }
    // lib.optionalAttrs isWorkstation {
      ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.tmux.conf";
    };
in {
  xdg.configFile = configDirs;
  home.file = rootFiles;
}
