# Security — GPG agent with SSH support, mtr network diagnostics
{
  # Setcap wrapper for mtr (traceroute + ping)
  programs.mtr.enable = true;

  # GPG agent with SSH key management
  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
  };
}
