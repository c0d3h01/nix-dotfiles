{
  userConfig,
  lib,
  ...
}: {
  # AppImage support
  programs.appimage = {
    enable = userConfig.workstation;
    binfmt = true;
  };
}
