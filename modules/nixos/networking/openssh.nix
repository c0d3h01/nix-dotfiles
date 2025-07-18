{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkMerge;
  inherit (self.lib) mkPubs;
in
{
  boot.initrd.network.ssh.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGjkQQxG24k1crCI4dcW4Alkd+a1vgz8iQ/omjA+qgq"
  ];

  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    allowSFTP = true;

    banner = ''
      Connected to ${config.system.name} @ ${config.system.configurationRevision}
    '';

    settings = {
      # Don't allow root login
      PermitRootLogin = "no";

      # only allow key based logins and not password
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
      UsePAM = false;

      UseDns = false;
      X11Forwarding = false;

      # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
        "diffie-hellman-group-exchange-sha256"
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
      ];

      # Use Macs recommended by `nixpkgs#ssh-audit`
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];

      # kick out inactive sessions
      ClientAliveCountMax = 5;
      ClientAliveInterval = 60;
    };

    openFirewall = true;
    # the port(s) openssh daemon should listen on
    ports = [ 22 ];

    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    # find these with `ssh-keyscan <hostname>`
    knownHosts = mkMerge [
      (mkPubs "github.com" [
        {
          type = "rsa";
          key = "AAAAB3NzaC1yc2EAAAADAQABAAACAQClVn6cInE32qWBN3Bi4eBdxWAhyS6DBU1wGpfSQjqq6RNDNbqJi7/yLN4mynzCYonTxF3UpIMj1oHXKoOO8z/X+vc28DqtOMLtVFOUBENiUECra0QPlHKUmCUzWF4aPwSCisqfIgQwfF69XE0p1ACBFyF+4Br8SP4jgus0ev0OK35mIZ/7AR5bw8xrWnh5tjjhDIJ4TC6Lh49AMR+P7cQ1GH3e5B2cCSljqS35FMzXG4jXAiwP00hNjtA11lbvb+rDuam6Hnnu6er+RBdqeIzfQtuGVk/RZocu7UxofE2sqzSvN1BzEyAkTJar53r1WFZCTY+hhf0LV7OVx1IsruEdhNbKfbjSe4O0I6uUA6vAiEyd0Wj4qkUGoxKKWS/LV8/S6GF/SnWDgKjORhZN83Os0jEik7LXSa9BYmESLJxF/axyhTqLeErTWL5alNZ9sE/nY1zYwUn1vwCTLCrv2khjND0viApH3QIub04a4QToDy82AP7k/RXTGDmtL8ZfB9ubXQUkOaaBDeqhMI3Sua5+v/MuxVAo2p3DVWNLAcA1u54anNQ1zrAmJuufe/Wm3rDqPZ0+xP+blC1I/xpm1HzXdTll5AXTE+KHHXCX0hHNp1CZlgGdgKlzAZxt8apRDpIUpcDyX+HsRyFT0WX1fk7vZWQ85rStnfvVwHvDsBMpnw==";
        }
        {
          type = "ed25519";
          key = "AAAAC3NzaC1lZDI1NTE5AAAAIOGjkQQxG24k1crCI4dcW4Alkd+a1vgz8iQ/omjA+qgq";
        }
      ])

      (mkPubs "gitlab.com" [
        {
          type = "rsa";
          key = "AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
        }
        {
          type = "ed25519";
          key = "AAAAC3NzaC1lZDI1NTE5AAAAIOGjkQQxG24k1crCI4dcW4Alkd+a1vgz8iQ/omjA+qgq";
        }
      ])
    ];
  };
}
