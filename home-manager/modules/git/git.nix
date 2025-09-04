{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;

  ghCredHelper = "!${pkgs.gh}/bin/gh auth git-credential";

  # Use 1Password's signer on macOS; use ssh-keygen on Linux (default/portable)
  sshSignerProgram =
    if isDarwin then
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      "${pkgs.openssh}/bin/ssh-keygen";
in
{
  home = {
    file.".gitattributes".source = ./gitattributes;
    file.".gitmessage".source = ./gitmessage;
  };

  programs.git = {
    enable = true;

    # Identity
    userName = "Harshal Sawant";
    userEmail = "harshalsawant.dev@gmail.com";

    # Signing (SSH-based signing)
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    # LFS
    lfs.enable = true;

    # Delta pager
    delta = {
      enable = true;
      options = {
        navigate = "true";
        side-by-side = "false";
        line-numbers = "true";
        syntax-theme = "TwoDark";
      };
    };

    # Aliases
    aliases = {
      st = "status";
      br = "branch --all";
      lg = ''log --graph --decorate --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --abbrev-commit'';
      f = "fetch --all --prune";
      pf = "push --force-with-lease";
      pl = "pull";
      pr = "pull --rebase";
      dt = "difftool";
      amend = "commit -a --amend";
      wip = "!git add -u && git commit -m \"WIP\"";
      undo = "reset HEAD~1 --mixed";
      ignore = ''!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/"$@"; }; gi'';
      trim = "!git remote prune origin && git gc";
    };

    # Global ignores
    ignores = [
      # system residue
      ".cache/"
      ".DS_Store"
      ".Trashes"
      ".Trash-*"
      "*.bak"
      "*.swp"
      "*.swo"
      "*.elc"
      ".~lock*"

      # build residue
      "tmp/"
      "target/"
      "result"
      "result-*"
      "*.exe"
      "*.exe~"
      "*.dll"
      "*.so"
      "*.dylib"

      # dependencies
      ".direnv/"
      "node_modules"
      "vendor"
    ];

    # Everything else
    extraConfig = {
      # Init
      init.defaultBranch = "main";

      # Core
      core = {
        editor = "nvim";
        autocrlf = false;
        safecrlf = true;
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        preloadindex = true;
      };
      color.ui = "auto";

      # Diff & Difftool
      diff = {
        tool = "nvim";
        algorithm = "patience";
        renames = "copies";
        mnemonicPrefix = true;
        compactionHeuristic = true;
      };
      difftool = {
        prompt = false;
        "nvim".cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      };

      # Merge & Mergetool
      merge = {
        tool = "nvim";
        conflictStyle = "zdiff3";
        log = true;
      };
      mergetool = {
        keepBackup = false;
        "nvim".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c 'wincmd w' -c 'wincmd J'";
      };

      # Push / Pull / Fetch
      push = {
        default = "simple";
        autoSetupRemote = true;
        recurseSubmodules = "on-demand";
        followTags = true;
      };
      pull = {
        rebase = true;
        autostash = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        fsckObjects = true;
      };

      # Rebase
      rebase = {
        autosquash = true;
        autostash = true;
        updateRefs = true;
        stat = true;
      };

      # Branch & Status
      branch = {
        autoSetupRebase = "always";
        sort = "-committerdate";
      };
      status = {
        showUntrackedFiles = "all";
        submoduleSummary = true;
      };

      # Logging
      log = {
        abbrevCommit = true;
        decorate = "short";
        date = "relative";
      };

      # Performance
      feature.manyFiles = true;
      index.threads = 0; # auto-select threads

      # Commit & Format
      commit = {
        verbose = true;
        template = "~/.config/git/gitmessage";
      };
      format = {
        signoff = false;
        pretty = "fuller";
      };

      # Rerere
      rerere = {
        enabled = true;
        autoupdate = true;
      };

      # Submodules
      submodule = {
        fetchJobs = 4;
        recurse = true;
      };

      # Help / Tag
      help.autocorrect = 10;
      tag.sort = "-version:refname";

      # SSH signing
      gpg.format = "ssh";
      gpg.ssh.program = sshSignerProgram;
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

      # Security
      transfer.fsckObjects = true;
      receive.fsckObjects = true;

      # HTTP (disable low-speed timeouts)
      http = {
        cookiefile = "~/.gitcookies";
        lowSpeedLimit = 0;
        lowSpeedTime = 0;
      };

      # Advice
      advice = {
        statusHints = false;
        detachedHead = false;
        skippedCherryPicks = false;
        pushUpdateRejected = false;
      };

      # URL Shortcuts
      url = {
        "git@github.com:".insteadOf = [
          "gh:"
          "github:"
        ];
        "git@github.com:".pushInsteadOf = [ "git://github.com/" ];
        "git://github.com/".insteadOf = "github:";
        "git@gist.github.com:".insteadOf = [
          "gst:"
          "gist:"
        ];
        "git@gist.github.com:".pushInsteadOf = [ "git://gist.github.com/" ];
        "git://gist.github.com/".insteadOf = "gist:";
      };

      # Auth
      credential.helper = if isDarwin then "osxkeychain" else "libsecret";
    };
  };
}
