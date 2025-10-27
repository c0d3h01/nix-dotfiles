{ userConfig, lib, ... }:

{
  services.tabby = lib.mkIf userConfig.devStack.tabby.enable {
    enable = true;
    port = 8080;
    acceleration = "rocm"; # "cuda" for nvidia | "rocm" for AMD | false for CPU
  };
  networking.firewall.allowedTCPPorts = [ 8080 ];
}

