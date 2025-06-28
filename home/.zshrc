# Core Configuration
export LC_ALL="en_IN.UTF-8"

# The Go lang exports
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export PATH="$PATH:$GOBIN"

# Set R_LIBS_USER for custom library path
export R_LIBS_USER=~/R/x86_64-library/%v

# Editor/Terminal/Browser Selection
set_default() {
  for cmd in "$@"; do
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "$cmd"
      return
    fi
  done
}
EDITOR_CMD="$(set_default nvim vim)"
[ -n "$EDITOR_CMD" ] && export EDITOR="$EDITOR_CMD" VISUAL="$EDITOR_CMD"
case "$EDITOR_CMD" in
  nvim) export MANPAGER="nvim +Man!";;
  vim)  export MANPAGER="vim +Man!";;
esac

TERMINAL_CMD="$(set_default ghostty kitty)"
[ -n "$TERMINAL_CMD" ] && export TERMINAL="$TERMINAL_CMD"

BROWSER_CMD="$(set_default firefox firefox-esr brave)"
if [ -n "$BROWSER_CMD" ]; then
  export BROWSER="$BROWSER_CMD"
  export CHROME_EXECUTABLE="$(command -v "$BROWSER_CMD")"
fi

if command -v java >/dev/null 2>&1; then
  export JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
fi

# Android SDK Configuration
if [ -d "$HOME/Android" ]; then
  export ANDROID_HOME="$HOME/Android"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  for p in "$ANDROID_HOME/cmdline-tools/latest/bin" "$ANDROID_HOME/platform-tools" "$ANDROID_HOME/emulator"; do
    [ -d "$p" ] && PATH="$PATH:$p"
  done
  [ -d "$HOME/Android/flutter/bin" ] && PATH="$HOME/Android/flutter/bin:$PATH"
fi

# Path Configuration
for dir in "$HOME/.local/bin" "$HOME/.rustup" "$HOME/.cargo/bin" "$HOME/go/bin" \
           "$HOME/.npm-global/bin" "$HOME/bin" "$HOME/.cabal/bin" "$HOME/.cargo/env"; do
  [ -d "$dir" ] && PATH="$dir:$PATH"
done
typeset -U path
export PATH

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
# ls/lsd
alias l='lsd -l --group-dirs first --color auto'
alias ls='lsd --group-dirs first --color auto'
alias ll='lsd -l --header --classify --size short --group-dirs first --date "+%Y-%m-%d %H:%M" --all --color auto'
alias la='lsd -a --group-dirs first --color auto'
alias lt='lsd --tree --depth 2 --group-dirs first --color auto'
alias lta='lsd --tree --depth 2 -a --group-dirs first --color auto'
alias ltg='lsd --tree --depth 2 --ignore-glob ".git" --group-dirs first --color auto'
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
alias gph='git push'
alias gpl='git pull --rebase'
alias gl='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gst='git stash'
alias gsp='git stash pop'
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
# Modern alternatives
alias v='nvim'
alias vi='nvim'
# Handy
alias cl='clear'
alias x='exit'
alias nc='nix-collect-garbage'
alias home-check='journalctl -u home-manager-$USER.service'
alias hm='home-manager'
alias ts='date "+%Y-%m-%d %H:%M:%S"'
alias reload='source ~/.zshrc'

# R aliases and helpers
alias r="R --vanilla"
alias rscript="Rscript"
alias rdev="R -q --no-save"
alias rlint="Rscript -e 'lintr::lint_dir()'"
alias rfmt="Rscript -e 'styler::style_dir()'"

# Home manager evironment
if [ -f "/etc/profiles/per-user" ]; then
  . /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
elif [ -f "~/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# Nix environment
if [ -f "/etc/profile.d/nix.sh" ]; then
  . /etc/profile.d/nix.sh
elif [ -f "~/.nix-profile/etc/profile.d/nix.sh" ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Ghostty terminal integration
[ -f "~/.nix-profile/zsh/ghostty-integration" ] && . ~/.nix-profile/zsh/ghostty-integration

# Darwin/Nix/Remote
[[ $OSTYPE == darwin* ]] && export NIX_PATH="$NIX_PATH:darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix"
[[ -S /nix/var/nix/daemon-socket/socket ]] && export NIX_REMOTE=daemon

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

# Direnv hook if available
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Kubectl alias and autocompletion if available
if command -v kubectl >/dev/null 2>&1; then
  alias k=kubectl
  source <(kubectl completion zsh)
fi

# Tool Initialization
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd j)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Starship prompt
# command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Custom Plugin Submodules
if (( $+commands[fzf] )); then
  source "$HOME/.zsh-fzf-tab/fzf-tab.zsh"
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

fpath+=("$HOME/.zsh-completions")
[[ -d ~/.zsh-completions/src ]] && fpath+=("$HOME/.zsh-completions/src")
[[ -d ~/.nix-profile/share/zsh/site-functions ]] && fpath+=("$HOME/.nix-profile/share/zsh/site-functions")
[[ -d /run/current-system/sw/share/zsh/site-functions/ ]] && fpath+=("/run/current-system/sw/share/zsh/site-functions/")

# zsh-autosuggestions
source "$HOME/.zsh-autosuggestions/zsh-autosuggestions.zsh"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=60"

if (( $+commands[fzf-share] )); then
  FZF_CTRL_R_OPTS=--reverse
  (( $+commands[fd] )) && export FZF_DEFAULT_COMMAND='fd --type f'
  source "$(fzf-share)/key-bindings.zsh"
fi

fignore=(.DS_Store $fignore)


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

# fzf shell integration
[ -f "$HOME/.fzf/shell/key-bindings.zsh" ] && source "$HOME/.fzf/shell/key-bindings.zsh"
[ -f "$HOME/.fzf/shell/completion.zsh" ]   && source "$HOME/.fzf/shell/completion.zsh"

# fzf-tab
source "$HOME/.zsh-fzf-tab/fzf-tab.zsh"

# Prevent broken terminals by resetting to sane defaults after a command
ttyctl -f
