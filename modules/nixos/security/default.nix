# Security — GPG agent, SSH agent, sops secrets
{
  imports = [
    # keep-sorted start
    ./gnupg.nix
    ./secrets.nix
    # keep-sorted end
  ];
}
