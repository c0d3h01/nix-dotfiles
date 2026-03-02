# Purpose: sops-nix secret management for home-manager
{
  inputs,
  self,
  config,
  ...
}: {
  imports = [
    # keep-sorted start
    inputs.sops.homeManagerModules.sops
    # keep-sorted end
  ];

  sops = {
    defaultSopsFile = "${self}/secrets/default.yaml";
    age.sshKeyPaths = [
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ];
  };
}
