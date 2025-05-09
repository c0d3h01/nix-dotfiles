{
  pkgs,
  ...
}:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
    ];
  };
}
