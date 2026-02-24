{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;

    signing = {
      key = "A7A7A1725FBF10AB04BF1355B4242C21BAF74B7C";
      signByDefault = true;
    };

    ignores =
      lib.filter (l: l != "" && !lib.hasPrefix "#" l)
      (lib.splitString "\n" (builtins.readFile ./ignore));

    attributes =
      lib.filter (l: l != "")
      (lib.splitString "\n" (builtins.readFile ./attributes));

    settings = {
      user = {
        name = "Harshal Sawant";
        email = "harshalsawant.dev@gmail.com";
      };
      alias = {
        l = "log --oneline --decorate --graph --all";
        lg = "log --graph --pretty=format:'%C(yellow)%h%Creset %C(cyan)%ad%Creset%C(red)%d%Creset %s %C(blue)[%an]%Creset' --date=short";
        last = "log -1 HEAD --stat";
        f = "fetch --prune";
        fa = "fetch --all --prune --tags";
        p = "push";
        pl = "pull --rebase";
        c = "commit";
        cm = "commit --message";
        ca = "commit --all --message";
        amend = "commit --amend --no-edit";
        fixup = "commit --fixup";
        rb = "rebase --interactive --autosquash";
        rbc = "rebase --continue";
        rba = "rebase --abort";
        cp = "cherry-pick";
        unstage = "reset HEAD --";
        co = "checkout";
        sw = "switch";
        sync = "!git fetch --all --prune --tags && git rebase --autostash --rebase-merges @{u}";
        wt = "worktree";
      };
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore";
        attributesfile = "~/.config/git/attributes";
      };
      init.defaultBranch = "main";
      push = {
        default = "current";
        autoSetupRemote = true;
        followTags = true;
        useForceIfIncludes = true;
      };
      pull = {
        rebase = true;
        ff = "only";
      };
      fetch = {
        prune = true;
        pruneTags = true;
      };
      merge.conflictstyle = "zdiff3";
      rebase = {
        autosquash = true;
        autoStash = true;
        updateRefs = true;
        rebaseMerges = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      commit = {
        gpgsign = true;
        verbose = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "zebra";
        renames = true;
      };
      status.submoduleSummary = true;
      branch.sort = "-committerdate";
      tag.sort = "-version:refname";
      "url \"git@github.com:\"".insteadOf = "https://github.com/";
      gpg.program = "gpg";
      protocol.version = 2;
    };
  };
}
