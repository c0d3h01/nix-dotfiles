# Export Configuration
export LANG="en_IN.UTF-8"
export LC_ALL="$LANG"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export TERMINAL="kitty"
export BROWSER="firefox"
export CHROME_EXECUTABLE="$(command -v "$BROWSER")"
export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"

# SDK Configurations
[ -d "$HOME/Android" ] && export ANDROID_HOME="$HOME/Android"
[ -d "$ANDROID_HOME" ] && export ANDROID_SDK_ROOT="$ANDROID_HOME"
[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
[ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$PATH:$ANDROID_HOME/platform-tools"
[ -d "$ANDROID_HOME/emulator" ] && export PATH="$PATH:$ANDROID_HOME/emulator"
[ -d "$HOME/Android/flutter/bin" ] && export PATH="$HOME/Android/flutter/bin:$PATH"

# Nix profile to PATH and XDG_DATA_DIRS
[ -d "$HOME/.nix-profile/bin" ] && export PATH="$HOME/.nix-profile/bin:$PATH"
[ -d "$HOME/.nix-profile/share" ] && XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
[ -d "/usr/share" ] && XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"
export XDG_DATA_DIRS

# Path Configuration
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.npm-global/bin" ] && export PATH="$HOME/.npm-global/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

# Rust | Cargo
[ -d "$HOME/.rustup" ] && export PATH="$HOME/.rustup:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# The Go lang exports
[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"

# Home manager evironment
if [ -f "/etc/profiles/per-user" ]; then
  source /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
elif [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# Nix environment
if [ -f "/etc/profile.d/nix.sh" ]; then
  source /etc/profile.d/nix.sh
elif [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

# Darwin/Nix/Remote
[[ $OSTYPE == darwin* ]] && export NIX_PATH="$NIX_PATH:darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix"
[[ -S /nix/var/nix/daemon-socket/socket ]] && export NIX_REMOTE=daemon

# Tool Configurations
export LESS="-R -F"
export FZF_DEFAULT_OPTS="
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
"

# Zsh Features
autoload -Uz colors && colors

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTORY_IGNORE="(rm *|pkill *|kill *|shutdown *|reboot *|exit)"
setopt append_history extended_history hist_expire_dups_first hist_ignore_all_dups hist_verify inc_append_history share_history

# Completion system
autoload -Uz compinit
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
compinit -d "$HOME/.cache/zsh/.zcompdump"

# Zsh Options
setopt auto_pushd pushd_ignore_dups pushd_silent cdable_vars autocd extended_glob \
       interactive_comments short_loops rc_quotes no_flow_control no_beep ignore_eof \
       multios no_hup rm_star_silent complete_in_word
unsetopt always_to_end

# Key Bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^f' vi-forward-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if command -v lsd >/dev/null; then
  # ls/lsd
  alias l='lsd -l --group-dirs first --color auto'
  alias ls='lsd --group-dirs first --color auto'
  alias ll='lsd -l --header --classify --size short --group-dirs first --date "+%Y-%m-%d %H:%M" --all --color auto'
  alias la='lsd -a --group-dirs first --color auto'
  alias lt='lsd --tree --depth 2 --group-dirs first --color auto'
  alias lta='lsd --tree --depth 2 -a --group-dirs first --color auto'
  alias ltg='lsd --tree --depth 2 --ignore-glob ".git" --group-dirs first --color auto'
fi

# Git
alias g='git'
alias ga='git add'
alias gs='git status -sb'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpr='git pull --rebase'
alias gl='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias top='htop'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias find='fd'
alias mkdir='mkdir -pv'
alias ping='ping -c 5'
alias wget='wget -c'
alias ports='ss -tulpn'

# Safety net
alias rm='rm -Iv --one-file-system'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'

# Shortty Hand commands
alias v="$EDITOR"
alias vi="$EDITOR"
alias cl='clear'
alias x='exit'
alias nc='nix-collect-garbage'
alias home-check='journalctl -u home-manager-$USER.service'
alias hm='home-manager'
alias ts='date "+%Y-%m-%d %H:%M:%S"'
alias reload='source ~/.zshrc'
alias k=kubectl

# R aliases and helpers
alias r="R --vanilla"
alias rscript="Rscript"
alias rdev="R -q --no-save"
alias rlint="Rscript -e 'lintr::lint_dir()'"
alias rfmt="Rscript -e 'styler::style_dir()'"

# ===== Functions =====

path() { echo -e "${PATH//:/\\n}" | bat; }

extract() {
  local file="$1" dir="${2:-.}"
  [[ ! -f "$file" ]] && echo "Error: '$file' not valid" >&2 && return 1
  case "$file" in
    *.tar.bz2|*.tbz2)  tar -xjf "$file" -C "$dir" ;;
    *.tar.gz|*.tgz)    tar -xzf "$file" -C "$dir" ;;
    *.tar.xz|*.txz)    tar -xJf "$file" -C "$dir" ;;
    *.bz2)             bunzip2 -k "$file" ;;
    *.rar)             unrar x "$file" "$dir" ;;
    *.gz)              gunzip -k "$file" ;;
    *.tar)             tar -xf "$file" -C "$dir" ;;
    *.zip)             unzip "$file" -d "$dir" ;;
    *.Z)               uncompress "$file" ;;
    *.7z)              7z x "$file" -o"$dir" ;;
    *.deb)             ar x "$file" ;;
    *)                 echo "Cannot extract '$file'" >&2; return 1 ;;
  esac && echo "Extracted '$file' to '$dir'"
}

mkcd() { mkdir -p "$1" && cd "$1"; }

fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --height 40% --reverse) && cd "$dir"
}

glf() {
  git log --color=always --format="%C(auto)%h%d %s %C(green)%cr %C(bold blue)<%an>%Creset" "$@" | \
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview "git show --color=always {1}" \
        --bind "enter:execute(git show {1})+accept"
}

colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;%sm%3d\e[0m " "$i" "$i"
    (( (i + 1) % 16 == 0 )) && printf "\n"
  done
}

flake-check() {
  if [ $# -lt 1 ]; then
    nix flake check
  else
    for arg in "$@"; do
      nix build ".#checks.$(nix eval --impure --raw --expr builtins.currentSystem).$arg"
    done
  fi
}

make() {
  local build_path
  build_path="$(dirname "$(upfind "Makefile")")"
  command nice -n19 make -C "${build_path:-.}" -j"$(nproc)" "$@"
}

# Helper: wrap_command(tool fallback func_name)
wrap_command() {
  local tool="$1" fallback="$2" func_name="$3"
  if command -v "$tool" >/dev/null 2>&1; then
    eval "${func_name}() {
      if [[ -t 1 && -o interactive ]]; then
        $tool \"\$@\"
      else
        command $fallback \"\$@\"
      fi
    }"
  fi
}
wrap_command bat cat cat
wrap_command fastfetch fastfetch ff
wrap_command rg grep grep

# Tool Initialization
eval "$(zoxide init zsh --cmd j)"
eval "$(direnv hook zsh)"

# Starship prompt
# eval "$(starship init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
source "$(fzf-share)/key-bindings.zsh"
FZF_DEFAULT_COMMAND='fd --type f'
FZF_CTRL_R_OPTS=--reverse

# fzf tab
if (( $+commands[fzf] )); then
  source "$HOME/.fzf-tab/fzf-tab.zsh"
  [[ -n $TMUX ]] && zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  zstyle ':completion:*:git-checkout:*' sort false
  zstyle ':completion:*:descriptions' format '[%d]'
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  zstyle ':completion:*' menu no
  if (( $+commands[lsd] )); then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
  fi
  zstyle ':fzf-tab:*' switch-group '<' '>'
fi

# Zsh completions plugin
fpath=("$HOME/.zsh-completions/src" $fpath)

# zsh-autosuggestions
source "$HOME/.zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=60,bold,underline"

# Pure Prompt
fpath+=($HOME/.zsh-pure)
# fpath+=("$(brew --prefix)/share/zsh/site-functions") # For Homebrew
zstyle :prompt:pure:path color yellow
zstyle :prompt:pure:git:branch color yellow
zstyle :prompt:pure:user color cyan
zstyle :prompt:pure:host color yellow
zstyle :prompt:pure:git:branch:cached color red
zstyle :prompt:pure:git:stash show yes
autoload -U promptinit; promptinit
prompt pure

# zsh-autopair
source "$HOME/.zsh-autopair/autopair.zsh"

# fast-syntax-highlighting
source "$HOME/.zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Launch Zellij automatically
# eval "$(zellij setup --generate-auto-start zsh)"
if command -v zellij >/dev/null; then
  if [[ -z "$ZELLIJ" && -z "$ZELLIJ_SESSION_NAME" && -z "$TMUX" ]]; then
    if [[ -z "$SSH_CONNECTION" && $- == *i* ]]; then
      exec zellij
    fi
  fi
fi

# Prevent broken terminals by resetting to sane defaults after a command
ttyctl -f
