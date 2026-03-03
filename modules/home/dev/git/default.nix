{
  pkgs,
  lib,
  userConfig,
  ...
}: {
  imports = [
    ./lazygit.nix
  ];

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
      (lib.splitString "\n" (builtins.readFile ./gitignore));

    attributes =
      lib.filter (l: l != "")
      (lib.splitString "\n" (builtins.readFile ./gitattributes));

    settings = {
      user = {
        name = "Harshal Sawant";
        email = "harshalsawant.dev@gmail.com";
      };
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore";
        attributesfile = "~/.config/git/attributes";
      };
      init.defaultBranch = "master";
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
