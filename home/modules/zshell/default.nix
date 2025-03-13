{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";

    history = {
      extended = true;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 15000;
      size = 15000;
      path = "${config.xdg.dataHome}/zsh/history";
      share = true;
    };

    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Modern ls replacements
      ls = "eza --icons --group-directories-first --time-style=long-iso";
      ll = "eza -l --icons --group-directories-first --git";
      la = "eza -a --icons --group-directories-first";
      lt = "eza --tree --icons --level=2";
      ltg = "eza --tree --icons --level=2 --git-ignore";

      # Git
      g = "git";
      ga = "git add";
      gs = "git status";
      gd = "git diff --color=always $@ | diff-so-fancy";
      gc = "git commit";
      gcm = "git commit -m";
      gph = "git push";
      gpl = "git pull --rebase";
      glo = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";

      # Safety nets
      rm = "rm -I";
      cp = "cp -i";
      mv = "mv -i";

      # System
      df = "df -h | eza";
      du = "dust";
      ps = "procs";
      cat = "bat";
      top = "btm";
      ip = "ip -color=auto";
      grep = "rg";
      find = "fd";

      # Additional shellAliases
      ff = "fastfetch";
      cl = "clear";
      x = "exit";
      v = "nvim";
      d = "dirs -v | head -10";

      # Nix
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/.";
      ncg = "sudo nix-collect-garbage -d";
      npkgs = "nix repl nixpkgs";
      ns = "nix search nixpkgs";
      nr = "nix run nixpkgs#";
      nf = "nix flake";
      nd = "nix develop";

      # Docker
      ubuntu = "docker run -it ubuntu bash";
      fedora = "docker run -it fedora bash";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
        };
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "23.07.13";
          sha256 = "1357hygrjwj5vd4cjdvxzrx967f1d2dbqm2rskbz5z1q6jri1hm3";
        };
      }
    ];

    envExtra = ''
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export PATH="$HOME/.npm-global/bin:$PATH"
      export NVM_DIR="$HOME/.config/nvm"
      export EDITOR="nvim"
      export VISUAL="nvim"
      export MANPAGER="nvim +Man!"
      export MANWIDTH=80
      export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --height 40% --layout=reverse --border --preview-window=right:60% \
        --preview 'bat --style=numbers --color=always --line-range :500 {}'"
      
      export BAT_THEME="Catppuccin-mocha"
      export EXA_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
    '';

    initExtra = ''
      # Lazy load NVM
        nvm() {
          unset -f nvm
          [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
          nvm "$@"
        }

        # Lazy load Direnv
        direnv() {
          unset -f direnv
          eval "$(direnv hook zsh)"
          direnv "$@"
        }

        # Lazy load Zoxide
        z() {
          unset -f z
          eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
          z "$@"
        }

        # Extract archives
        extract() {
          if [-f "$1"]; then
            case "$1" in
            *.tar.gz) tar xzf "$1";;
            *.tar.xz) tar xJf "$1";;
            *.tar.bz2) tar xjf "$1";;
            *.zip) unzip "$1";;
            *) echo "Unsupported file formmat!";;
          esac
          else
            echo "File not found: $1"
          fi
        }

        # FZF integration
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

        # Enable Powerline glyphs
        export POWERLINE=true
      
        # Improved Vi mode
        bindkey -v
        # Better vi mode integration
        bindkey '^?' backward-delete-char
        bindkey '^h' backward-delete-char
        bindkey '^w' backward-kill-word
        export KEYTIMEOUT=1
      
        # Cursor customization
        zle-keymap-select() {
          case $KEYMAP in
            vicmd) echo -ne "\033[2 q" ;;  # Block cursor
            viins|main) echo -ne "\033[6 q" ;; # Beam cursor
          esac
        }
        zle -N zle-keymap-select
        echo -ne "\033[6 q"  # Initial beam cursor
      
        # FZF integration
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
      
        # Enhanced completion colors
        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*' group-name '''
        zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
        # Case-insensitive completion
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      
        # Directory stack navigation
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$os"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      add_newline = false;
      scan_timeout = 10;
      command_timeout = 1000;

      # OS Section
      os = {
        disabled = false;
        style = "bold blue";
        symbols = {
          NixOS = " NixOS";
        };
      };

      # Username Section
      username = {
        style_user = "bold green";
        style_root = "bold red";
        format = "[ ⥈ $user]($style) ";
        show_always = true;
      };

      # Hostname Section
      hostname = {
        style = "bold yellow";
        format = "[$hostname]($style) ";
      };

      # Directory Section
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        style = "bold cyan";
        read_only_style = "red";
        read_only = " ";
        substitutions = {
          "Documents" = " ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
        format = "[ $path]($style)";
      };

      # Git Branch Section
      git_branch = {
        symbol = "  ";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      # Git Status Section
      git_status = {
        style = "bold yellow";
        conflicted = " x ";
        ahead = " ⇡ ";
        behind = " ⇣ ";
        diverged = " ⇕ ";
        untracked = " ? ";
        stashed = " § ";
        modified = " ! ";
        staged = " + ";
        renamed = " » ";
        deleted = " ✘ ";
      };

      # Nix Shell Section
      nix_shell = {
        symbol = "❄️ ";
        format = "[$symbol$name]($style) ";
        style = "bold blue";
      };

      # Command Duration Section
      cmd_duration = {
        min_time = 1000;
        format = "[⏱ $duration]($style) ";
        style = "bold magenta";
      };

      # Prompt Character Section
      character = {
        success_symbol = "[⇝ ](bold green)";
        error_symbol = "[✗ ](bold red)";
        vicmd_symbol = "[V ](bold blue)";
      };

      # Right Prompt (Time)
      right_format = "$time";
      time = {
        disabled = false;
        time_format = "%T"; # 24-hour format
        style = "bold dimmed white";
        format = "[⏱  $time]($style)";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "bg+" = "#313244";
      "bg" = "#1e1e2e";
      "spinner" = "#f5e0dc";
      "hl" = "#f38ba8";
      "fg" = "#cdd6f4";
      "header" = "#f38ba8";
      "info" = "#cba6f7";
      "pointer" = "#f5e0dc";
      "marker" = "#f5e0dc";
      "fg+" = "#cdd6f4";
      "prompt" = "#cba6f7";
      "hl+" = "#f38ba8";
    };
  };
}
