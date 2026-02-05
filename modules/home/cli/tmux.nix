{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 10;
    keyMode = "vi";
    newSession = true;
    prefix = "C-a";
    terminal = "tmux-256color";

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];

    extraConfig = ''
      unbind C-b
      bind C-a send-prefix

      set -g mouse on
      set -g history-limit 100000
      set -g renumber-windows on
      set -g status-interval 5

      set -g status-style "bg=#1b1f27,fg=#c8d0e0"
      set -g message-style "bg=#1b1f27,fg=#c8d0e0"
      set -g pane-border-style "fg=#3a3f4b"
      set -g pane-active-border-style "fg=#6c8cff"

      set -g status-left "#[fg=#6c8cff]#S #[fg=#5f6b7a]|"
      set -g status-right "#[fg=#5f6b7a]%Y-%m-%d #[fg=#c8d0e0]%H:%M"

      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
