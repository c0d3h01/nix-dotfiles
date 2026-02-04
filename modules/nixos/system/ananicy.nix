{userConfig, ...}: {
  services.ananicy.enable = userConfig.workstation or false;
}
