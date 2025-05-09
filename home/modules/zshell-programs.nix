{
  lib,
  pkgs,
  ...
}:
let
  darkgray = "242"; # Starship
in
{
  programs = {

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        prettybat
      ];
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };

    eza = {
      enable = true;
      extraOptions = [
        "--classify"
        "--color-scale"
        "--git"
        "--group-directories-first"
      ];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--color=dark"
        "--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe"
        "--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef"
      ];
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--pretty"
      ];
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$git_metrics"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$nix_shell"
          "$direnv"
          "$character"
        ];

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vicmd_symbol = "[❮](bold green)";
        };

        directory = {
          style = "bold blue";
          read_only = " !";
          truncation_symbol = "…/";
        };

        git_branch = {
          format = "[$branch]($style) ";
          style = darkgray;
        };

        git_status = {
          format = "([$all_status$ahead_behind]($style) )";
          style = "bold purple";
          conflicted = "= ";
          ahead = "⇡$count ";
          behind = "⇣$count ";
          diverged = "⇕⇡$ahead_count⇣$behind_count";
          untracked = "? ";
          stashed = "≡ ";
          modified = "! ";
          staged = "+ ";
          renamed = "» ";
          deleted = "✘ ";
        };

        git_state = {
          format = "([$state( $progress_current/$progress_total)]($style)) ";
          style = "bright-black";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
          min_time = 2000;
        };

        nix_shell = {
          format = "[$symbol]($style) ";
          symbol = "❄️ ";
          style = "bold blue";
        };

        python = {
          format = "[$symbol$version$virtualenv]($style) ";
          style = "bold yellow";
        };

        username = {
          format = "[$user]($style) ";
          style_user = "bold dimmed green";
          style_root = "bold red";
          show_always = true;
        };

        hostname = {
          format = "[$hostname]($style) ";
          style = "bold dimmed green";
          ssh_only = false;
        };
      };
    };
  };
}
