{
  lib,
  userConfig,
  pkgs,
  ...
}:
let
  inherit (lib) optionals;
  isWorkstation = userConfig.machineConfig.montools;
in
{
  home.packages =
    with pkgs;
    optionals isWorkstation [
      # Recon & Scanning
      amass # DNS subdomain enumeration
      whois # Domain WHOIS lookup
      dnsutils # DNS query utilities (dig, nslookup)
      dnsenum # DNS enumeration
      nmap # Network scanner
      p0f # Passive OS fingerprinting
      onesixtyone # SNMP scanner
      theharvester # OSINT email/host gathering

      # Web Pentesting
      burpsuite # Web app pentesting proxy
      zap # OWASP ZAP web app scanner
      dirb # Web content scanner
      gobuster # Directory & DNS brute-forcing
      nikto # Web server vulnerability scanner
      wpscan # WordPress vulnerability scanner
      sqlmap # SQL injection testing

      # Wireless & Network Tools
      aircrack-ng # Wi-Fi WEP/WPA cracking suite
      wifite2 # Automated wireless auditing
      hcxtools # Convert Wi-Fi captures for hashcat/john
      hcxdumptool # Capture packets from Wi-Fi
      reaverwps-t6x # WPS PIN brute force
      kismet # Wireless packet sniffer
      arping # ARP ping tool
      bettercap # MITM framework
      tcpdump # Packet capture tool
      tshark # CLI packet analysis
      # wireshark      # Network traffic analyzer

      # Exploitation
      metasploit # Exploitation framework
      exploitdb # Exploit database

      # Password Cracking
      hydra # Network logon cracker
      thc-hydra # Alternate hydra package
      john # Hash cracking tool
      hashcat # GPU-based hash cracker
      crunch # Wordlist generator
      fcrackzip # ZIP password cracker
      cewl # Custom wordlist generator from websites
      ldapnomnom # LDAP user brute force
      msldapdump # LDAP enumeration

      # Packet Analysis / MITM
      ettercap # MITM attack framework
      mitmproxy # HTTPS proxy for MITM
      sslscan # SSL/TLS scanner
      testssl # SSL/TLS configuration tester
      certgraph # SSL certificate graph crawler

      # Reverse Engineering & Forensics
      ghidra # Reverse engineering framework
      radare2 # Reverse engineering toolkit
      iaito # GUI for radare2
      binwalk # Analyze binary blobs and firmware
      exiftool # Metadata extraction
      volatility3 # Memory forensics tool
      ghorg # Mass clone git repos (OSINT/code review)

      # Other Security Tools
      deepsecrets # Find secrets in code
    ];
}
