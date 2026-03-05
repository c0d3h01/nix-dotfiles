{pkgs, ...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # Use fd as the default finder
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";

    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border=rounded"
      "--info=inline"
      "--margin=1"
      "--padding=1"
    ];

    # Catppuccin Mocha inspired colors
    colors = {
      fg = "#cdd6f4";
      "fg+" = "#cdd6f4";
      bg = "#1e1e2e";
      "bg+" = "#313244";
      hl = "#f38ba8";
      "hl+" = "#f38ba8";
      info = "#cba6f7";
      prompt = "#cba6f7";
      pointer = "#f5e0dc";
      marker = "#b4befe";
      spinner = "#f5e0dc";
      header = "#f38ba8";
    };

    fileWidgetOptions = [
      "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"
    ];

    changeDirWidgetOptions = [
      "--preview '${pkgs.eza}/bin/eza --tree --color=always --icons --level=2 {} 2>/dev/null'"
    ];
  };
}
