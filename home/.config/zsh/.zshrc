#!/usr/bin/env zsh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM="xterm-256color"

# Zsh history location
export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=5000
export SAVEHIST=5000

# Zsh Options
export DISABLE_AUTO_TITLE="true"
export COMPLETION_WAITING_DOTS="false"
export HIST_STAMPS="dd.mm.yyyy"

setopt HIST_IGNORE_SPACE
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# CD settings
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt always_to_end
setopt interactive_comments

# Completion system
autoload -Uz compinit
zmodload zsh/complist
compinit -d

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:::::' completer _expand _complete _ignored _approximate

# FZF-tab config
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'

# Helper function
ifsource() { [ -f "$1" ] && source "$1"; }

# Credentials and hashes
ifsource "$HOME/.credentials"
ifsource "$ZDOTDIR/.zsh_dir_hashes"

# Plugin directory
PLUGIN_DIR="$ZDOTDIR/plugins"

# Source plugins
ifsource "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ifsource "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
ifsource "$PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh"
ifsource "$PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"
ifsource "$PLUGIN_DIR/fzf/shell/completion.zsh"
ifsource "$PLUGIN_DIR/fzf/shell/key-bindings.zsh"

# Autosuggestions config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"

# Custom configs
ifsource "$ZDOTDIR/exports.sh"
ifsource "$ZDOTDIR/functions.sh"
ifsource "$ZDOTDIR/aliases.sh"

# Tool initialization
eval "$(zoxide init zsh --cmd j)"
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

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
bindkey "${terminfo[kcuu1]}" history-search-backward
bindkey "${terminfo[kcud1]}" history-search-forward
export KEYTIMEOUT=1

# Load nix environment
ifsource /etc/profile.d/nix.sh
ifsource "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Prevent broken terminals
ttyctl -f

export NVM_DIR="$HOME/.local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
