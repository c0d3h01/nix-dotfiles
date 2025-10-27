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
    lfs.enable = true;

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      signByDefault = true;
    };

    settings = {
      user.name = "Harshal Sawant";
      user.email = "harshalsawant.dev@gmail.com";

      init.defaultBranch = "master";
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
        conflictStyle = "diff3";
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


