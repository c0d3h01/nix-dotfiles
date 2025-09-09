{
  imports = [
    ./fail2ban.nix
    ./firewall.nix
    ./networkManager.nix
    ./optimizations.nix
    ./ssh.nix
    ./systemd.nix
    ./tcpcrypt.nix
    # ./wireless.nix
  ];
}
