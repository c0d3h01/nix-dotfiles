{hostProfile, ...}: {
  services.bpftune.enable = hostProfile.isWorkstation;
}
