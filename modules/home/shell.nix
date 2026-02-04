{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      save = 100000;
      size = 100000;
      expireDuplicatesFirst = true;
      share = true;
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
      }
    ];

    initContent = ''
      # Use fzf for TAB completion via fzf-tab
      zstyle ':completion:*' menu select
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always --icons=auto $realpath'
      zstyle ':fzf-tab:complete:*:*' fzf-flags --height=60% --layout=reverse --info=inline
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "Nord";
    };
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.less = {
    enable = true;
    config = "vim";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less -FR";
  };
}
