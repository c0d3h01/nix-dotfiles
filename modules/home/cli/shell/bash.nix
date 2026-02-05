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

      # Helper function
      ifsource() { [ -f "$1" ] && source "$1"; }

      # Fzf Key Bindings
      if [ -f /usr/share/fzf/key-bindings.bash ]; then
          source /usr/share/fzf/key-bindings.bash
      elif [ -f "$HOME/.fzf/shell/key-bindings.bash" ]; then
          source "$HOME/.fzf/shell/key-bindings.bash"
      fi

      # Common navigation aliases
      alias ..='cd ..'
      alias ...='cd ../..'

      # System aliases
      alias cp='cp -i'
      alias mv='mv -i'
      alias grep='grep --color=auto'
      alias free='free -h'
      alias df='df -hT'
      alias du='du -hc'
      alias ip='ip -color=auto'
      alias diff='diff --color=auto'
      alias dd='dd status=progress'
      alias rm='rm -Iv --one-file-system --preserve-root'

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
