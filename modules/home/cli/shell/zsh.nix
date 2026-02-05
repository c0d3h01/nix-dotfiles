{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = ''

      # zsh settings
      export DISABLE_AUTO_TITLE="true"
      export COMPLETION_WAITING_DOTS="false"
      export HIST_STAMPS="dd.mm.yyyy"
      export HISTSIZE=5000
      export SAVEHIST=5000
      export HISTFILE="$HOME/.zsh_history"
      setopt HIST_IGNORE_SPACE
      setopt appendhistory
      setopt sharehistory
      setopt incappendhistory
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS

      # cd-ing settings
      setopt auto_cd
      setopt auto_list
      setopt auto_menu
      setopt always_to_end
      setopt interactive_comments
      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "$LS_COLORS"
      zstyle ':completion:::::' completer _expand _complete _ignored _approximate

      # Add zsh-completions to fpath (Nix-managed)
      fpath+=("${pkgs.zsh-completions}/share/zsh/site-functions")

      # Lazy load completions
      autoload -Uz compinit
      compinit -C

      # autosuggestions settings
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      ZSH_AUTOSUGGEST_USE_ASYNC="true"
      ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # Prevent rebinding on every prompt

      # fzf-tab
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

      # Helper function
      ifsource() { [ -f "$1" ] && source "$1"; }

      # Source plugins
      ifsource "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      ifsource "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
      ifsource "${pkgs.zsh-fast-syntax-highlighting}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

      # Helper functions
      add_to_path() {
      	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
      		path=("$1" $path)
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

      export K9S_CONFIG_DIR="$HOME/.config/k9s"

      # Extract archives
      extract() {
          local file="$1" dir="''${2:-.}"
          [[ ! -f "$file" ]] && { print -u2 "Error: '$file' not found"; return 1; }

          case "''${file:l}" in
              *.tar.bz2|*.tbz2) tar -xjf "$file" -C "$dir" ;;
              *.tar.gz|*.tgz)   tar -xzf "$file" -C "$dir" ;;
              *.tar.xz|*.txz)   tar -xJf "$file" -C "$dir" ;;
              *.tar.zst|*.tzst) tar -xf "$file" -C "$dir" ;;
              *.bz2)            bunzip2 -k "$file" ;;
              *.gz)             gunzip -k "$file" ;;
              *.tar)            tar -xf "$file" -C "$dir" ;;
              *.zip)            unzip -q "$file" -d "$dir" ;;
              *.7z)             7z x "$file" -o"$dir" ;;
              *.xz)             unxz -k "$file" ;;
              *.zst)            unzstd "$file" ;;
              *) print -u2 "Error: Unknown format"; return 1 ;;
          esac && print "✓ Extracted to '$dir'"
      }

      # Make dir and cd
      mkcd() {
          [[ -z "$1" ]] && { print -u2 "Usage: mkcd <dir>"; return 1; }
          mkdir -p "$1" && cd "$1"
      }

      # Smart make
      make() {
          local build_path="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
          [[ ! -f "$build_path/Makefile" ]] && build_path="."
          command nice -n 19 make -C "$build_path" -j"$(nproc)" "$@"
      }

      # Common navigation aliases
      alias ..='cd ..'
      alias ...='cd ../..'

      # System aliases
      alias cp='cp -i'
      alias mv='mv -i'
      alias grep='grep --color=always'
      alias ip='ip --color=always'
      alias diff='diff --color=always'
      alias rm='rm -Iv --one-file-system --preserve-root'

      # kubectl completion
      if command -v kubectl >/dev/null 2>&1; then
          source <(kubectl completion zsh)
      fi

      # Sops completion
      if command -v sops >/dev/null 2>&1; then
          source <(sops completion zsh)
      fi

      # load nix
      ifsource /etc/profile.d/nix.sh
      ifsource "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      # Source dir hashes
      ifsource "$HOME/.local/share/zsh/.zsh_dir_hashes"

      # LAZY LOAD NVM - Node Version Manager
      export NVM_DIR="$HOME/.local/share/nvm"
      nvm() {
          unset -f nvm node npm npx
          [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
          nvm "$@"
      }
      node() {
          unset -f nvm node npm npx
          [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
          node "$@"
      }
      npm() {
          unset -f nvm node npm npx
          [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
          npm "$@"
      }
      npx() {
          unset -f nvm node npm npx
          [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
          npx "$@"
      }

      # LAZY LOAD PYENV
      export PYENV_ROOT="$HOME/.pyenv"
      if [[ -d "$PYENV_ROOT/bin" ]]; then
          export PATH="$PYENV_ROOT/bin:$PATH"
          pyenv() {
              unset -f pyenv
              if command -v pyenv >/dev/null 2>&1; then
                  eval "$(pyenv init - zsh 2>/dev/null)"
                  pyenv "$@"
              else
                  echo "pyenv not found"
                  return 1
              fi
          }
      fi

      # Vim mode
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -v
      bindkey '^P' history-search-backward
      bindkey '^N' history-search-forward
      bindkey '^?' backward-delete-char
      bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      bindkey '^H' backward-kill-word
      bindkey '^[^?' backward-kill-word
      bindkey '^a' beginning-of-line
      bindkey '^e' end-of-line
      bindkey '^xe' edit-command-line
      bindkey '^x^e' edit-command-line
      bindkey "''${terminfo[kcuu1]}" history-search-backward
      bindkey "''${terminfo[kcud1]}" history-search-forward
      export KEYTIMEOUT=1

      # Prevent broken terminals
      ttyctl -f
    '';
  };
}
