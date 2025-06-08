{
  config,
  pkgs,
  declarative,
  lib,
  ...
}:

{
  options = {
    myModules.monitoring.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable monitoring tools suite";
    };
  };

  config = lib.mkIf config.myModules.monitoring.enable {

    environment.systemPackages = with pkgs; [
      # Recon & Scanning
      nmap
      zmap
      amass
      whois
      dnsutils
      theharvester

      # Web Pentesting
      burpsuite
      dirb
      gobuster
      sqlmap
      nikto
      wpscan

      # Wireless Tools
      aircrack-ng
      reaverwps-t6x
      kismet

      # Exploitation
      metasploit
      exploitdb

      # Password Cracking
      john
      hashcat
      hydra
      crunch
      cewl

      # Packet Analysis / MITM
      tshark
      ettercap
      tcpdump
      mitmproxy

      # Reverse Engineering
      radare2
      ghidra
      binwalk
      exiftool
      volatility3

      # Anonymity / VPN
      tor
      tor-browser-bundle-bin
      openvpn
      proxychains-ng
    ];
  };
}
