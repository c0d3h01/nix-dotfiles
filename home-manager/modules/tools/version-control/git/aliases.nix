{
  programs.git.settings.alias = {
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
}


