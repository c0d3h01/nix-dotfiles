{
  # This configuration creates the shell aliases across: bash, zsh and fish
  home.shellAliases = {
    # System
    du = "du -h";
    free = "free -h";
    ps = "ps auxf";
    top = "htop";
    ip = "ip -color=auto";
    diff = "diff --color=auto";
    find = "fd";
    ping = "ping -c 5";
    wget = "wget -c";
    ports = "ss -tulpn";
    mkdir = "mkdir -pv"; # always create pearent directory
    df = "df -h"; # human readblity
    reboot = "systemctl reboot";
    sysctl = "sudo systemctl";
    jctl = "journalctl -p 3 -xb"; # get error messages from journalctl

    # Safety net
    rm = "rm -Iv --one-file-system";
    cp = "cp -iv";
    mv = "mv -iv";
    ln = "ln -iv";

    # Shortty Hand commands
    v = "$EDITOR";
    vi = "$EDITOR";
    cl = "clear";
    x = "exit";
    nc = "nix-collect-garbage";
    home-check = "journalctl -u home-manager-$USER.service";
    hm = "home-manager";
    ts = "date '+%Y-%m-%d %H:%M:%S'";
    # reload = "source ~/.zshrc";
    k = "kubectl";
    lg = "lazygit";
    zzzpl = "cd ~/.local/share/zzz ; git pull ; git push ; cd -";
    zzzbk = "cd ~/.local/share/zzz ; git add . ; git commit -m 'chore: sync changes' ; git push ; cd -";

    # R aliases and helpers
    r = "R --vanilla";
    rscript = "Rscript";
    rdev = "R -q --no-save";
    rlint = "Rscript -e 'lintr::lint_dir()'";
    rfmt = "Rscript -e 'styler::style_dir()'";
  };
}
