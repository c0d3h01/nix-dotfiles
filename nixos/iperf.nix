{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.iperf3 ];
  networking.firewall.allowedTCPPorts = [ 5201 ];
  networking.firewall.allowedUDPPorts = [ 5201 ];
}
