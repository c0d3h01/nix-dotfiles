{ config, ... }:

{
  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    compression = true;

    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = config.sops.secrets.gh-key.path;
      };

      "gitlab.com" = {
        user = "git";
        hostname = "gitlab.com";
      };
    };
  };

  sops.secrets = {
    gh-key = { };
    gh-pub-key = { };
  };
}
