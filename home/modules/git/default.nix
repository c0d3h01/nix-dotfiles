{ user
, pkgs
, ...
}:
{
  programs.git = {
    enable = true;

    # User Configurations
    userName = "${user.username}";
    userEmail = "${user.email}";

    # Git Configuations
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      color.ui = true;
      fetch.prune = true;
      push.default = "current";

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
      ".envrc"
      # Build artifacts
      "dist/"
      "build/"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
    ];
  };
}
