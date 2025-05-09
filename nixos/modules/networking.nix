{
  services.resolved.enable = true;
  systemd.network.wait-online.enable = false;

  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    nameservers = [
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # SSH Daemon
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowAgentForwarding = true;
    };
  };
}
