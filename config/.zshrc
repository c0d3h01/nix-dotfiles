# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ZSH_CUSTOM=/path/to/new-custom-folder
ZSH_THEME="nicoulaj"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    fzf-tab
    zsh-autopair
    zsh-completions
    zsh-pure
)

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_IN.UTF-8
export EDITOR='nvim'
export ARCHFLAGS="-arch $(uname -m)"

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="15000"
SAVEHIST="15000"

HISTFILE="/home/c0d3h01/.local/share/.local/share/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt autocd

if [[ $options[zle] = on ]]; then
  eval "$(fzf --zsh)"
fi

# Improved completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"

# Improved Vi mode
bindkey -v
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# History substring search key bindings
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down
# bindkey -M vicmd 'k' history-substring-search-up
# bindkey -M vicmd 'j' history-substring-search-down

# Directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt EXTENDED_GLOB
setopt NO_BEEP
setopt MULTIOS
setopt DVORAK
setopt NO_HUP
setopt IGNORE_EOF
setopt PRINT_EIGHT_BIT
setopt RC_QUOTES
setopt RM_STAR_SILENT
setopt SHORT_LOOPS
setopt NO_FLOW_CONTROL

if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi

# Lazy load Zoxide
z() {
  unset -f z
  eval "$(zoxide init zsh)"
  z "$@"
}

function extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

eval "$(direnv hook zsh)"

alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- cat=bat
alias -- cl=clear
alias -- cp='cp -i'
alias -- diff='diff --color=auto'
alias -- eza='eza --classify --color-scale --git --group-directories-first'
alias -- ff=fastfetch
alias -- find=fd
alias -- g=git
alias -- ga='git add'
alias -- gc='git commit'
alias -- gph='git push'
alias -- gpl='git pull'
alias -- grep=rg
alias -- gs='git status'
alias -- ip='ip --color=auto'
alias -- l='eza -l --icons --group-directories-first'
alias -- la='eza -a --icons --group-directories-first'
alias -- ll='eza --header --git --classify --long --binary --group --time-style=long-iso --links --all --all --group-directories-first --sort=name'
alias -- lla='eza -la'
alias -- ls='eza --icons --group-directories-first'
alias -- lt='eza --tree --icons --level=2'
alias -- mkdir='mkdir -pv'
alias -- mv='mv -i'
alias -- ping='ping -c 5'
alias -- ports='netstat -tulpn'
alias -- rm='rm -I'
alias -- wget='wget -c'
alias -- x=exit