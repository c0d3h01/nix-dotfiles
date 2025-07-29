{ userConfig, lib, ... }:

{
  services.tabby = lib.mkIf (userConfig.dev ? tabby && userConfig.dev.tabby) {
    enable = true;
    port = 8080;
    acceleration = "rocm"; # or "rocm" for AMD, false for CPU
    model = "starcoder:1b"; # Default model
  };
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
