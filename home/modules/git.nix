{
  userConfig,
  pkgs,
  ...
}:
{
  programs = {
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;

      # User Configurations
      userName = userConfig.username;
      userEmail = userConfig.email;

      # Git Configuations
      extraConfig = {
        color.ui = true;
        diff.algorithm = "histogram";
        merge.conflictstyle = "zdiff3";
        branch.autosetuprebase = "always";
        pull.rebase = "merges";
        init.defaultBranch = "main";

        rebase = {
          autostash = true;
          updateRefs = true;
        };

        push = {
          default = "current";
          autosetupremote = true;
        };

        fetch = {
          prune = true;
          recurseSubmodules = true;
        };

        url = {
          "git@github.com:".insteadOf = "https://github.com/";
          "git@gitlab.com:".insteadOf = "https://gitlab.com/";
        };

        # Core helpful aliases
        alias = {
          st = "status";
          co = "checkout";
          ci = "commit";
          br = "branch";
          unstage = "reset HEAD --";
          graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        };
      };

      # Delta for better diffs
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
          syntax-theme = "ansi";
        };
      };

      # Common ignores
      ignores = [
        # General
        ".DS_Store"
        "Thumbs.db"
        # Editor files
        ".idea/"
        ".vscode/"
        "*.swp"
        # Environment files
        ".env"
        ".direnv/"
        # Build artifacts
        "dist/"
        "build/"
        "node_modules/"
        "__pycache__/"
        "*.pyc"
      ];
    };
  };
}
