{
  lib,
  pkgs,
  userConfig,
  ...
}: {
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  config = lib.mkIf userConfig.workstation {
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      path = [pkgs.flatpak];
      after = ["network-online.target"];
      wants = ["network-online.target"];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
