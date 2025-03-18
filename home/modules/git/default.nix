{ config, username, useremail, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "${username}";
    userEmail = "${useremail}";

    extraConfig = {
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      pull.rebase = true;
      color.ui = true;
      fetch.prune = true;
      push.default = "current";

      # Helpful aliases
      alias = {
        st = "status";
        co = "checkout";
        ci = "commit";
        br = "branch";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
        graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };

    # Delta is a syntax-highlighting pager for git
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "ansi";
      };
    };

    # Advanced git attributes
    attributes = [
      "*.pdf diff=pdf"
      "*.html diff=html"
      "*.md diff=markdown"
    ];

    # Enable git-ignore
    ignores = [
      # General
      ".DS_Store"
      "Thumbs.db"

      # Editor files
      ".idea/"
      ".vscode/"
      "*.swp"
      "*.swo"

      # Environment files
      ".env"
      ".env.local"
      ".direnv/"
      ".envrc"

      # Build artifacts
      "dist/"
      "build/"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
      ".pytest_cache/"
    ];
  };
}

