{ lib, ... }: {

  services.resolved.enable = true;
  systemd.network.wait-online.enable = false;

  networking = {
    networkmanager = {
      enable = true;
      connectionConfig."connection.mdns" = 2; # enabled
      wifi.powersave = false;
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # SSH Daemon
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      AllowAgentForwarding = true;
    };
  };
}
