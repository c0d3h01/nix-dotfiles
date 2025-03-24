{ config, pkgs, lib, ... }:

{
  # ZSH configuration  
  programs.zsh = {
    enable = true;

    # Essential ZSH features
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";

    # History configuration - keeping your existing settings
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

    # Keeping your useful aliases
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Modern ls replacements
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first --git";
      la = "eza -a --icons --group-directories-first";
      lt = "eza --tree --icons --level=2";

      # Git shortcuts
      g = "git";
      ga = "git add";
      gs = "git status";
      gc = "git commit";
      gph = "git push";
      gpl = "git pull";

      # Safety nets
      rm = "rm -I";
      cp = "cp -i";
      mv = "mv -i";

      # Modern alternatives
      cat = "bat";
      grep = "rg";
      find = "fd";

      # Handy shortcuts
      ff = "fastfetch";
      cl = "clear";
      x = "exit";
      v = "nvim";

      # Nix
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/. --upgrade --show-trace";
      ncg = "sudo nix-collect-garbage -d";
    };

    # Using oh-my-zsh as a pre-configured solution
    oh-my-zsh = {
      enable = true;

      # Theme with minimal setup required
      theme = "robbyrussell";

      # Useful plugins from oh-my-zsh
      plugins = [
        "git"
        "z"
        "sudo"
        "colored-man-pages"
        "command-not-found"
        "fzf"
      ];
    };

    # Essential plugins not included in oh-my-zsh
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
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
    ];

    # Environment setup
    envExtra = ''
      export CHROME_EXECUTABLE="/etc/profiles/per-user/c0d3h01/bin/firefox"
      export MANPAGER="nvim +Man!"
    '';

    # Functional config
    initExtra = ''
      # Improved Vi mode
      bindkey -v
      bindkey '^?' backward-delete-char
      bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      
      # Directory stack
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      
      # Extract function
      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.gz) tar xzf "$1" ;;
            *.tar.xz) tar xJf "$1" ;;
            *.tar.bz2) tar xjf "$1" ;;
            *.zip) unzip "$1" ;;
            *) echo "Unsupported file format!" ;;
          esac
        else
          echo "File not found: $1"
        fi
      }
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Starship config with Catppuccin colors
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      add_newline = false;

      directory = {
        style = "bold cyan";
        truncation_length = 3;
        format = "[$path]($style) ";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold yellow";
        format = "[$all_status$ahead_behind]($style) ";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold blue)";
      };
    };
  };

  # Essential complementary tools
  programs.fzf.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
