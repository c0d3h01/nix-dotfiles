#!/usr/bin/env bash
# shellcheck disable=1091,2034

# ===== Core Configuration =====
export LC_ALL=en_IN.UTF-8
export NIX_USER_PROFILE_DIR="${NIX_USER_PROFILE_DIR:-/nix/var/nix/profiles/per-user/${USER}}"
export NIX_PROFILES="${NIX_PROFILES:-$HOME/.nix-profile}"
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
export DEVENVSHELL=1

# ===== Editor & Terminal =====
if command -v nvim >/dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
  export MANPAGER="nvim +Man!"
elif command -v vim >/dev/null; then
  export EDITOR="vim"
  export VISUAL="vim"
  export MANPAGER="vim +Man!"
fi

if command -v ghostty >/dev/null; then
  export TERMINAL="ghostty"
elif command -v kitty >/dev/null; then
  export TERMINAL="kitty"
fi

# ===== Browser =====
if command -v firefox >/dev/null; then
  BROWSER="firefox"
  CHROME_EXECUTABLE="$(command -v firefox)"
  export BROWSER CHROME_EXECUTABLE
elif command -v firefox-esr >/dev/null; then
  BROWSER="firefox-esr"
  CHROME_EXECUTABLE="$(command -v firefox-esr)"
  export BROWSER CHROME_EXECUTABLE
elif command -v brave >/dev/null; then
  BROWSER="brave"
  CHROME_EXECUTABLE="$(command -v brave)"
  export BROWSER CHROME_EXECUTABLE
fi

# ===== Java =====
if command -v java >/dev/null; then
  JAVA_HOME="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
  export JAVA_HOME
fi

# ===== Android SDK =====
[ -d "$HOME/Android" ] && export ANDROID_HOME="$HOME/Android"
[ -d "$ANDROID_HOME" ] && export ANDROID_SDK_ROOT="$ANDROID_HOME"
[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
[ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$PATH:$ANDROID_HOME/platform-tools"
[ -d "$ANDROID_HOME/emulator" ] && export PATH="$PATH:$ANDROID_HOME/emulator"
[ -d "$HOME/Android/flutter/bin" ] && export PATH="$HOME/Android/flutter/bin:$PATH"

# ===== Path Configuration =====
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.rustup" ] && export PATH="$HOME/.rustup:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"
[ -d "$HOME/.npm-global/bin" ] && export PATH="$HOME/.npm-global/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.cabal/bin" ] && export PATH="$HOME/.cabal/bin:$PATH"

# ===== Tool Configurations =====
export LESS="-R -F"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ===== History Configuration =====
HISTSIZE=10000
HISTFILESIZE=10000
HISTFILE=~/.bash_history
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="&:ls:[bf]g:exit:cd:clear:history:pwd"
shopt -s histappend

# ===== OH-MY-BASH Initialization =====
OSH_THEME="agnoster"
OSH="$HOME/.oh-my-bash"

plugins=(
    aws
    ansible
    cargo
    fzf
    git
    goenv
    golang
    npm
    pyenv
    starship
    sudo
    zoxide
)

# Oh My Bash initialization
if [ -f "$HOME/.oh-my-bash/oh-my-bash.sh" ]; then
  source "$HOME/.oh-my-bash/oh-my-bash.sh"
fi

# Bash Completion
if [ -f "$HOME/.bash-completion/bash_completion" ]; then
  source "$HOME/.bash-completion/bash_completion"
fi

# FZF (fuzzy finder) key bindings and completion
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

# ===== Environment & Profile Sourcing =====
# shellcheck source=/dev/null
[ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ] && source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
[ -e /etc/profile.d/nix.sh ] && . /etc/profile.d/nix.sh
# shellcheck source=/dev/null
[ -e ~/.nix-profile/etc/profile.d/nix.sh ] && . ~/.nix-profile/etc/profile.d/nix.sh
# shellcheck source=/dev/null
[ -f ~/.nix-profile/zsh/ghostty-integration ] && . ~/.nix-profile/zsh/ghostty-integration
[[ $OSTYPE == darwin* ]] && export NIX_PATH="$NIX_PATH:darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix"
[[ -S /nix/var/nix/daemon-socket/socket ]] && export NIX_REMOTE=daemon

# ===== Custom Aliases =====
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Modern ls replacements with lsd
alias l='lsd -l --group-dirs first --color auto'
alias ls='lsd --group-dirs first --color auto'
alias ll='lsd -l --header --classify --size short --group-dirs first --date "+%Y-%m-%d %H:%M" --all --color auto'
alias la='lsd -a --group-dirs first --color auto'
alias lt='lsd --tree --depth 2 --group-dirs first --color auto'
alias lta='lsd --tree --depth 2 -a --group-dirs first --color auto'
alias ltg='lsd --tree --depth 2 --ignore-glob ".git" --group-dirs first --color auto'

# Git shortcuts
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
alias gl="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gst='git stash'
alias gsp='git stash pop'

# System utilities
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
alias untar='tar -xvf'
alias grep='rg --color=always --line-number --smart-case --no-heading'

# Safety nets
alias rm='rm -Iv --one-file-system'
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -iv'

# Modern alternatives
alias v='nvim'
alias vi='nvim'

# Handy shortcuts
alias cl='clear'
alias x='exit'
alias nc='nix-collect-garbage'
alias home-check='journalctl -u home-manager-$USER.service'
alias hm='home-manager'
alias ts='date "+%Y-%m-%d %H:%M:%S"'
alias reload='source ~/.bashrc'

# ===== Custom Functions =====

# Print $PATH one entry per line, colored with bat
path() { echo -e "${PATH//:/\\n}" | bat; }

# Extract archive files
extract() {
  local file="$1" dir="${2:-.}"
  [ ! -f "$file" ] && echo "Error: '$file' not valid" >&2 && return 1
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
    *)                 echo "Cannot extract '$file'" >&2 && return 1 ;;
  esac && echo "Extracted '$file' to '$dir'"
}

# Make directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" || return; }

# Fuzzy cd into a directory using fd & fzf
fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --height 40% --reverse)
  [ -n "$dir" ] && cd "$dir" || return
}

# Fuzzy git log search with preview using fzf
glf() {
  git log --color=always --format="%C(auto)%h%d %s %C(green)%cr %C(bold blue)<%an>%Creset" "$@" | \
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview "git show --color=always {1}" \
        --bind "enter:execute(git show {1})+accept"
}

# Print terminal 256 color palette
colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;%sm%3d\e[0m " "$i" "$i"
    (( (i + 1) % 16 == 0 )) && printf "\n"
  done
}

# Make from nearest parent Makefile
make(){
  local build_path
  build_path="$(dirname "$(upfind "Makefile")")"
  command nice -n19 make -C "${build_path:-.}" -j"$(nproc)" "$@"
}

# Helper function to conditionally define command wrappers
wrap_command() {
  local tool="$1"
  local fallback="$2"
  local func_name="$3"
  if command -v "$tool" >/dev/null; then
    eval "${func_name}() {
      if [[ -t 1 ]]; then
        $tool \"\$@\"
      else
        command $fallback \"\$@\"
      fi
    }"
  fi
}

# Conditional wrappers
wrap_command bat cat bat
wrap_command fastfetch fastfetch ff
wrap_command rg grep rg
