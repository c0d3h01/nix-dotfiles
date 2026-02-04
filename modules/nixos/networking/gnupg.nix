{
  # configure a setcap wrapper
  programs.mtr.enable = true;

  # Gpg Agent with SSH support
  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
  };
}
