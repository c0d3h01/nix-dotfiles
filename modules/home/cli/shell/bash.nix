_: {
  programs.bash = {
    enable = true;
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

      # Fzf Auto-Completion
      if [ -f /usr/share/fzf/completion.bash ]; then
          source /usr/share/fzf/completion.bash
      elif [ -f "$HOME/.fzf/shell/completion.bash" ]; then
          source "$HOME/.fzf/shell/completion.bash"
      fi

      # Enable programmable completion features
      if ! shopt -oq posix; then
          if [ -f /usr/share/bash-completion/bash_completion ]; then
              source /usr/share/bash-completion/bash_completion
          elif [ -f /etc/bash_completion ]; then
              source /etc/bash_completion
          fi
      fi

      export EDITOR="nvim"
      export VISUAL="nvim"
      export BROWSER=
      export DIFFTOOL='icdiff'
      export LC_ALL="en_IN.UTF-8"
      export LANG="en_IN.UTF-8"
      export TERM="xterm-256color"

      # Detect shell type
      if [ -n "$ZSH_VERSION" ]; then
      	SHELL_TYPE="zsh"
      elif [ -n "$BASH_VERSION" ]; then
      	SHELL_TYPE="bash"
      else
      	SHELL_TYPE="sh"
      fi

      # Helper functions
      add_to_path() {
      	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      		if [ "$SHELL_TYPE" = "zsh" ]; then
      			path=("$1" $path)
      		else
      			export PATH="$1:$PATH"
      		fi
      	fi
      }

      ifsource() {
      	[ -f "$1" ] && . "$1"
      }

      # Android
      if [ -d "$HOME/Android" ]; then
      	export CHROME_EXECUTABLE="$BROWSER"
      	export ANDROID_HOME="$HOME/Android/Sdk"
      	export ANDROID_SDK_ROOT="$ANDROID_HOME"
      	export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/latest"
      	export NDK_HOME="$ANDROID_NDK_HOME"
      	export JAVA_HOME="$HOME/Android/jdk"
      	export FLUTTER_HOME="$HOME/Android/flutter"
      	add_to_path "$ANDROID_HOME/cmdline-tools/latest/bin"
      	add_to_path "$ANDROID_HOME/platform-tools"
      	add_to_path "$ANDROID_HOME/emulator"
      	add_to_path "$ANDROID_HOME/build-tools/36.1.0"
      	add_to_path "$NDK_HOME"
      	add_to_path "$JAVA_HOME/bin"
      	add_to_path "$FLUTTER_HOME/bin"
      fi

      # Go
      export GOPATH="$HOME/.local/share/go"
      export GOBIN="$GOPATH/bin"
      add_to_path "$GOBIN"

      # NVM - Node Version Manager
      export NVM_DIR="$HOME/.local/share/nvm"
      [ -d "$NVM_DIR" ] || mkdir -p "$NVM_DIR"

      # Other tools
      add_to_path "$HOME/.local/share/solana/install/active_release/bin"

      # Local bins
      add_to_path "$HOME/.avm/bin"
      add_to_path "$HOME/.local/bin"
      add_to_path "$HOME/.local/share/npm-global/bin"

      # Bun
      export BUN_INSTALL="$HOME/.local/share/bun"
      add_to_path "$BUN_INSTALL/bin"

      # Rust Build Environment
      export CARGO_HOME="$HOME/.local/share/.cargo"
      if [ -f "$CARGO_HOME/env" ]; then
          source "$CARGO_HOME/env"
      fi
      add_to_path "$HOME/.local/share/.cargo/bin"

      # Tool configs
      export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
      export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

      export K9S_CONFIG_DIR="$HOME/.config/k9s"

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

      # Load direnv integration
      if command -v direnv &>/dev/null; then
          eval "$(direnv hook bash)"
      fi

      # Starship prompt
      if [ -n "''${commands[starship]}" ]; then
        eval "$(starship init bash)"
      fi

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
