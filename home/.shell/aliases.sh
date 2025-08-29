#!/usr/bin/env bash

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

# System
alias df='df -h'
alias free='free -h'
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
alias v='$EDITOR'
alias vi='$EDITOR'
alias cl='clear'
alias x='exit'
alias nc='nix-collect-garbage'
alias home-check='journalctl -u home-manager-$USER.service'
alias hm='home-manager'
alias k=kubectl
alias grep='rg'

# R aliases and helpers
alias r="R --vanilla"
alias rscript="Rscript"
alias rdev="R -q --no-save"
alias rlint="Rscript -e 'lintr::lint_dir()'"
alias rfmt="Rscript -e 'styler::style_dir()'"
