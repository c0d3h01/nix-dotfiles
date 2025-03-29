{ config
, pkgs
, ...
}:
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
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "z"
        "sudo"
        "colored-man-pages"
        "command-not-found"
        "fzf"
      ];
    };

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
      export MANPAGER="nvim +Man!"
    '';

    # Functional config
    initExtra = ''
      # Improved Vi mode
      bindkey -v
      bindkey '^?' backward-delete-char
      bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-w  
      # Directory stack
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
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
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
