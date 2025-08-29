#!/usr/bin/env bash

ensure_dir() { [ -d "$1" ] || mkdir -p "$1"; }
ifsource(){ [ -f "$1" ] && source "$1"; }

# rustup and cargo
ifsource "$HOME/.local/share/cargo/env"
export RUSTFLAGS="-C link-arg=-fuse-ld=mold"
export CARGO_BUILD_JOBS=8
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=clang

# solana
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# android
export ANDROID_HOME="$HOME/Android"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK="$ANDROID_HOME/android-ndk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_NDK"

# Flutter & Dart
export FLUTTER_HOME="$HOME/Android/flutter"
export PATH="$PATH:$FLUTTER_HOME/bin"
export PATH="$PATH:$FLUTTER_HOME/bin/cache/dart-sdk/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Chrome executable for flutter
export CHROME_EXECUTABLE="$(which firefox)"

# Java Home
export JAVA_HOME="$(which java)"

# dotnet
export PATH="$PATH":"$HOME/.dotnet"

# Path Configuration
[ -d "$HOME/.npm-global/bin" ] && export PATH="$HOME/.npm-global/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

# Golang
export GOPATH=$HOME/.local/share/go
export GOBIN=$GOPATH/bin
PATH=$PATH:$GOPATH/bin

# Homebrew
PATH=$PATH:/opt/homebrew/bin

# Poetry
PATH="$HOME/.local/share/poetry/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.local/share/pyenv"
PATH="$PYENV_ROOT/bin:$PATH"

# Python
export WORKON_HOME=$HOME/.local/share/virtual-envs

# ruby
export GEM_HOME=$HOME/.local/cache/gems
export PATH=$HOME/.local/cache/gems/bin:$PATH

# node
export NVM_DIR="$HOME/.local/nvm"
ifsource "$NVM_DIR/nvm.sh"
ifsource "$NVM_DIR/bash_completion"

# deno
export PATH="$HOME/.deno/bin:$PATH"

# Latex (macos)
PATH=/Library/TeX/texbin:$PATH

# Nix profile to PATH and XDG_DATA_DIRS
[ -d "$HOME/.nix-profile/bin" ] && export PATH="$HOME/.nix-profile/bin:$PATH"
[ -d "$HOME/.nix-profile/share" ] && XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
[ -d "/usr/share" ] && XDG_DATA_DIRS="/usr/share:$XDG_DATA_DIRS"
export XDG_DATA_DIRS

# PATH (extras)
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.local/bin/random:$PATH
PATH=$HOME/.local/bin/helpers:$PATH
PATH=$HOME/.local/bin/utils:$PATH
PATH=$HOME/.local/bin/backpocket:$PATH
PATH=$HOME/.local/bin/macos:$PATH
PATH=$HOME/.local/bin/git:$PATH
PATH=$HOME/.local/bin/jj:$PATH
PATH=$HOME/.local/bin/docker:$PATH
PATH=$HOME/.local/bin/kubernetes:$PATH
PATH=$HOME/.local/bin/music:$PATH
PATH=$HOME/.local/bin/tmux:$PATH
PATH=$HOME/.local/bin/ai:$PATH
export PATH

# task spooler
export TS_MAXFINISHED="13"
# export TS_ONFINISH="tscomplete"

# fzf
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_DEFAULT_OPTS='
 -0
 --prompt=" "
 --inline-info
 --reverse --height "40%"
 --color fg:-1,hl:4,fg+:1,bg+:-1,hl+:4
 --color info:108,prompt:242,spinner:108,pointer:1,marker:168
'

# enable docker buildkit
export DOCKER_BUILDKIT=1

# open dlv breakpoint in Emacs
export DELVE_EDITOR=",emacs-no-wait"

# aider
export AIDER_GITIGNORE=false # present in global gitignore
export AIDER_CHECK_UPDATE=false # managed via nix

# k9s
export K9S_CONFIG_DIR="$HOME/.config/k9s"