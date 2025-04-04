{
  # GPG Agent (without SSH)
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # SSH Daemon
  services.openssh = {
    enable = true;
    # openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      MaxAuthTries = 3;
    };
  };
}
