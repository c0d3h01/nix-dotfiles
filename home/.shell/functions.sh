#!/usr/bin/env bash

path() { printf "%s\n" "$PATH" | tr ':' '\n' | bat; }

extract() {
  file="$1" dir="${2:-.}"
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
    *)                 echo "Cannot extract '$file'" >&2; return 1 ;;
  esac && echo "Extracted '$file' to '$dir'"
}

mkcd() { mkdir -p "$1" && cd "$1" || return; }

fcd() {
  dir=$(fd --type d --hidden --exclude .git | fzf --height 40% --reverse) && cd "$dir" || return;
}

make() {
  build_path="$(dirname "$(upfind "Makefile")")"
  command nice -n19 make -C "${build_path:-.}" -j"$(nproc)" "$@"
}

# Helper: wrap_command(tool fallback func_name)
wrap_command() {
  tool="$1" fallback="$2" func_name="$3"
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
