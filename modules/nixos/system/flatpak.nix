{
  lib,
  hostProfile,
  ...
}: {
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  config = lib.mkIf hostProfile.isWorkstation {
    services.flatpak.enable = false;
  };
}
