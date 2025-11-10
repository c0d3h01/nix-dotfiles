{ config, ... }:
{
  programs.bash = {
    enable = false;
    enableCompletion = true;

    historyFile = "${config.xdg.stateHome}/bash/history";
    historyFileSize = 1000;
    historySize = 100;

    shellOptions = [
      "cdspell"
      "checkjobs"
      "checkwinsize"
      # "globstar"
      "histappend"
    ];
  };
}
