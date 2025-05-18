{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.myModules.hackerMode = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable monitoring tools";
  };

  config = lib.mkIf config.myModules.hackerMode {
    home.packages = with pkgs; [
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
      wireshark
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
