{pkgs, ...}: {
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
      ATTRS{id/bus}=="ata", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
  '';
}
