_: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      # Bash history configuration
      export HISTFILE="$HOME/.bash_history"
      export HISTSIZE=5000
      export HISTFILESIZE=5000
      export HISTCONTROL=ignoredups:ignorespace
      export HISTTIMEFORMAT="%d.%m.%Y %T "
      shopt -s histappend
      shopt -s histverify
      shopt -s cmdhist

      # Bash shell options
      shopt -s autocd
      shopt -s cdspell
      shopt -s dirspell
      shopt -s nocaseglob
      shopt -s checkwinsize

      # Vi mode for Bash
      set -o vi
      bind -m vi-insert "\C-p":history-search-backward
      bind -m vi-insert "\C-n":history-search-forward
      bind -m vi-insert "\C-?":backward-delete-char
      bind -m vi-insert "\C-h":backward-delete-char
      bind -m vi-insert "\C-w":backward-kill-word
      bind -m vi-insert "\C-H":backward-kill-word
      bind -m vi-insert "\C-a":beginning-of-line
      bind -m vi-insert "\C-e":end-of-line
      bind -m vi-insert "\C-xe":edit-and-execute-command
      export KEYTIMEOUT=1
    '';
  };
}
