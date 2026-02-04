{
  lib,
  pkgs,
  userConfig,
  ...
}: {
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  config = lib.mkIf userConfig.workstation {
    services.flatpak.enable = true;
  };
}
