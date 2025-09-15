{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  sshSignerProgram =
    if isDarwin then
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else
      "${pkgs.openssh}/bin/ssh-keygen";
in
{
  programs.git = {
    enable = true;

    userName = "Harshal Sawant";
    userEmail = "harshalsawant.dev@gmail.com";

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };

    lfs.enable = true;

    delta = {
      enable = true;
      options = {
        navigate = "true";
        side-by-side = "false";
        line-numbers = "true";
        syntax-theme = "TwoDark";
        light = "false";
      };
    };

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
      amend-last = "commit --amend --no-edit";
      wip = "!git add -A && git commit -m 'WIP'";
      undo = "reset HEAD~1 --mixed";
      ignore = ''!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/"$@"; }; gi'';
      trim = "!git remote prune origin && git gc";
      remotes = "remote --verbose";
      contributors = "shortlog --summary --numbered";
      cloner = "clone --recursive";
      update = "!git pull && git submodule update --init --recursive";
      snapshot = "!git stash push -m \"snapshot: $(date +%Y-%m-%d_%H-%M-%S)\" && git stash apply stash@{0}";
      fixup = "!f() { git commit --fixup \"$1\"; }; f";
      squash = "!f() { git commit --squash \"$1\"; }; f";
      last = "diff HEAD~1";
      root = "rev-parse --show-toplevel";
    };

    extraConfig = {
      init.defaultBranch = "main";

      credential.helper = "store";

      protocol.version = 2;
      color.ui = "auto";

      core = {
        editor = "nvim";
        autocrlf = false;
        safecrlf = true;
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        preloadindex = true;
        untrackedCache = true;
        excludesFile = "${config.home.homeDirectory}/.config/git/ignore";
        attributesFile = "${config.home.homeDirectory}/.config/git/attributes";
      };

      diff = {
        tool = "nvim";
        algorithm = "histogram";
        renames = "copies";
        mnemonicPrefix = true;
        compactionHeuristic = true;
        colorMoved = "default";
        colorMovedWS = "ignore-space-change";
      };

      difftool = {
        prompt = false;
        "nvim".cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      };

      merge = {
        tool = "nvim";
        conflictStyle = "zdiff3";
        log = true;
      };

      mergetool = {
        keepBackup = false;
        "nvim".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c 'wincmd w' -c 'wincmd J'";
      };

      push = {
        default = "current";
        autoSetupRemote = true;
        recurseSubmodules = "on-demand";
        followTags = true;
      };

      pull = {
        rebase = "merges";
        autostash = true;
      };

      fetch = {
        prune = true;
        pruneTags = true;
        fsckObjects = true;
        writeCommitGraph = true;
        negotiationAlgorithm = "skipping";
      };

      rebase = {
        autosquash = true;
        autostash = true;
        updateRefs = true;
        stat = true;
      };

      branch = {
        autoSetupRebase = "always";
        sort = "-committerdate";
      };

      status = {
        showUntrackedFiles = "all";
        submoduleSummary = true;
        aheadBehind = true;
      };

      log = {
        abbrevCommit = true;
        decorate = "short";
        date = "relative";
        showSignature = true;
      };

      # Performance / maintenance
      feature.manyFiles = true;
      index.threads = 0;
      index.version = 4;
      gc.writeCommitGraph = true;
      commitGraph.generationVersion = 2;
      maintenance.auto = 1;
      maintenance.strategy = "incremental";
      pack.useBitmaps = true;

      commit = {
        verbose = true;
        cleanup = "strip";
        template = "${config.home.homeDirectory}/.config/git/message";
        status = true;
      };

      format = {
        signoff = false;
        pretty = "fuller";
      };

      rerere = {
        enabled = true;
        autoupdate = true;
      };

      submodule = {
        fetchJobs = 4;
        recurse = true;
      };

      help.autocorrect = "prompt";
      tag.sort = "-version:refname";

      gpg.format = "ssh";
      gpg.ssh.program = sshSignerProgram;
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      tag.gpgSign = true;

      transfer.fsckObjects = true;
      receive.fsckObjects = true;

      protocol.file.allow = "user";
      protocol.ext.allow = "never";

      http.cookiefile = "~/.gitcookies";

      advice = {
        statusHints = false;
        detachedHead = false;
        skippedCherryPicks = false;
        pushUpdateRejected = false;
      };

      # URL shortcuts
      url = {
        "ssh://aur@aur.archlinux.org/".insteadOf = "aur:";
        "ssh://git@codeberg.org/".insteadOf = "cb:";
        "ssh://git@ssh.gitlab.freedesktop.org/".insteadOf = "fdo:";
        "ssh://git@github.com/".insteadOf = "gh:";
        "ssh://git@gitlab.com/".insteadOf = "gl:";
        "ssh://git@invent.kde.org/".insteadOf = "kde:";
        "ssh://git@git.lix.systems/".insteadOf = "lix:";
        "ssh://git@git.afnix.fr/".insteadOf = "afnix:";
        "ssh://git@stash.msk.avito.ru:7999/".insteadOf = "avito:";
      };
    };
  };
}
