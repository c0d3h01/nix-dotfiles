{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    defaultCommand = "fd --type file --follow --hidden --exclude .git --color=always";
    defaultOptions = [
      "--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
    ];
    fileWidgetCommand = "fd --type file --follow --hidden --exclude .git --color=always";
    changeDirWidgetCommand = "fd --type d --follow --hidden --exclude .git --color=always";
  };
}
