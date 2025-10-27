{ lib, ... }:
{
  home.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "-" = "cd -";

    # ls / lsd - FIXED: Proper shell escaping
    ls = "lsd --group-dirs=first --color=auto 2>/dev/null || ls --color=auto --group-directories-first";
    l = "lsd -l --group-dirs=first --color=auto 2>/dev/null || ls -lh";
    ll = "lsd -lA --header --classify --size=short --group-dirs=first --date='+%Y-%m-%d %H:%M' --color=auto 2>/dev/null || ls -lAh";
    la = "lsd -A --group-dirs=first --color=auto 2>/dev/null || ls -A";
    lt = "lsd --tree --depth=2 --group-dirs=first --color=auto 2>/dev/null || echo 'lsd not installed'";
    lta = "lsd --tree --depth=2 -A --group-dirs=first --color=auto 2>/dev/null || echo 'lsd not installed'";
    tree = "lsd --tree --color=auto 2>/dev/null || command tree";

    # Modern tools - FIXED: Removed command -v wrapper (redundant)
    find = "fd 2>/dev/null || command find";
    grep = "rg 2>/dev/null || command grep";
    cat = "bat --style=auto 2>/dev/null || command cat";
    top = "btop 2>/dev/null || command top";

    # System
    df = "df -h";
    du = "du -h";
    free = "free -h";
    ip = "ip -color=auto";
    diff = "diff --color=auto";

    # Safety - FIXED: Removed --one-file-system (causes issues with bind mounts)
    rm = "rm -Iv --preserve-root";
    cp = "cp -iv";
    mv = "mv -iv";
    ln = "ln -iv";
    mkdir = "mkdir -pv";

    # Quick commands - FIXED: Proper variable expansion
    v = "$EDITOR";
    vi = "$EDITOR";
    vim = "$EDITOR";
    cl = "clear";
    x = "exit";
    reload = "exec $SHELL"; # Works with bash/zsh/fish

    # Nix
    nc = "nix-collect-garbage";
    ncd = "nix-collect-garbage -d";
    hm = "home-manager";
    hms = "home-manager switch";
    hmb = "home-manager build";

    # Git
    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit -v";
    gcm = "git commit -m";
    gco = "git checkout";
    gcb = "git checkout -b";
    gd = "git diff";
    gl = "git pull";
    gp = "git push";
    gpf = "git push --force-with-lease"; # Safer force push
    gst = "git status";
    gss = "git status -s"; # Short status
    glog = "git log --oneline --decorate --graph";
    gloga = "git log --oneline --decorate --graph --all";

    # Kubernetes
    k = "kubectl";
    kg = "kubectl get";
    kga = "kubectl get all";
    kd = "kubectl describe";
    ka = "kubectl apply -f";
    kl = "kubectl logs";
    klf = "kubectl logs -f"; # Follow logs
    kex = "kubectl exec -it";

    # Docker
    d = "docker";
    dc = "docker compose"; # Updated: docker-compose -> docker compose
    dps = "docker ps";
    dpsa = "docker ps -a";
    di = "docker images";
    drm = "docker rm";
    drmi = "docker rmi";
    dlog = "docker logs -f";

    # Development - R
    r = "R --vanilla";
    rdev = "R -q --no-save";

    # Development - Python
    py = "python3";
    venv = "python3 -m venv";
    vact = "source venv/bin/activate 2>/dev/null || source .venv/bin/activate";

    # Development - Node/Bun
    b = "bun";
    br = "bun run";
    bi = "bun install";
    bt = "bun test";

    # Development - Rust
    c = "cargo";
    cb = "cargo build";
    cbr = "cargo build --release";
    cr = "cargo run";
    crr = "cargo run --release";
    ct = "cargo test";
    cc = "cargo check";
    ccl = "cargo clippy";
    cf = "cargo fmt";

    # tmux
    tm = "tmux";
    tma = "tmux attach -t";
    tmn = "tmux new -s";
    tml = "tmux list-sessions";
    tmk = "tmux kill-session -t";

    # Network
    myip = "curl -s https://api.ipify.org && echo";
    localip = "ip -4 addr show | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}' | grep -v 127.0.0.1";
    serve = "python3 -m http.server";
    ports = "ss -tuln"; # Show listening ports

    # System monitoring
    meminfo = "free -h && echo && ps aux --sort=-%mem | head -n 10";
    cpuinfo = "top -bn1 | head -n 5 && echo && ps aux --sort=-%cpu | head -n 10";
    diskinfo = "df -h && echo && du -sh /* 2>/dev/null | sort -rh | head -n 10";
  };
}


