{hostProfile, ...}: {
  services.scx = {
    enable = false; # hostProfile.isWorkstation;
    scheduler = "scx_lavd";
    extraArgs = [
      "--performance"
    ];
  };
}
