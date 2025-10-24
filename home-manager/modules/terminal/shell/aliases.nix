{ lib, ... }:
{
  home.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "-" = "cd -";

    # ls / lsd
    ls = "if command -v lsd &>/dev/null; then lsd --group-dirs=first --color=auto; else ls --color=auto --group-directories-first; fi";
    l = "if command -v lsd &>/dev/null; then lsd -l --group-dirs=first --color=auto; else ls -lh; fi";
    ll = "if command -v lsd &>/dev/null; then lsd -lA --header --classify --size=short --group-dirs=first --date='+%Y-%m-%d %H:%M' --color=auto; else ls -lAh; fi";
    la = "if command -v lsd &>/dev/null; then lsd -A --group-dirs=first --color=auto; else ls -A; fi";
    lt = "if command -v lsd &>/dev/null; then lsd --tree --depth=2 --group-dirs=first --color=auto; fi";
    lta = "if command -v lsd &>/dev/null; then lsd --tree --depth=2 -A --group-dirs=first --color=auto; fi";
    tree = "if command -v lsd &>/dev/null; then lsd --tree --color=auto; fi";

    # Modern tools
    find = "command -v fd &>/dev/null && fd || find";
    grep = "command -v rg &>/dev/null && rg || grep";
    cat = "command -v bat &>/dev/null && bat --style=auto || cat";
    top = "command -v btop &>/dev/null && btop || top";

    # System
    df = "df -h";
    du = "du -h";
    free = "free -h";
    ip = "ip -color=auto";
    diff = "diff --color=auto";

    # Safety
    rm = "rm -Iv --one-file-system --preserve-root";
    cp = "cp -iv";
    mv = "mv -iv";
    ln = "ln -iv";
    mkdir = "mkdir -pv";

    # Quick commands
    v = "\$EDITOR";
    vi = "\$EDITOR";
    cl = "clear";
    x = "exit";
    reload = "exec zsh";

    # Nix
    nc = "nix-collect-garbage";
    ncd = "nix-collect-garbage -d";
    hm = "home-manager";
    hms = "home-manager switch";

    # Git
    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit -v";
    gcm = "git commit -m";
    gco = "git checkout";
    gd = "git diff";
    gl = "git pull";
    gp = "git push";
    gst = "git status";
    glog = "git log --oneline --decorate --graph";

    # Kubernetes
    k = "kubectl";
    kg = "kubectl get";
    kd = "kubectl describe";
    ka = "kubectl apply -f";
    kl = "kubectl logs";

    # Docker
    d = "docker";
    dc = "docker-compose";
    dps = "docker ps";
    di = "docker images";

    # Development - R
    r = "R --vanilla";
    rdev = "R -q --no-save";

    # Development - Python
    py = "python3";
    venv = "python3 -m venv";

    # Development - Node/Bun
    b = "bun";
    br = "bun run";
    bi = "bun install";

    # Development - Rust
    c = "cargo";
    cb = "cargo build";
    cr = "cargo run";
    ct = "cargo test";
    cc = "cargo check";

    # tmux
    tm = "tmux";
    tma = "tmux attach -t";
    tml = "tmux list-sessions";

    # Network
    myip = "curl -s https://api.ipify.org && echo";
    serve = "python3 -m http.server";
  };
}
