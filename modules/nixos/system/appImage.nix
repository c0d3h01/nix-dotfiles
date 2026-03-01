{hostProfile, ...}: {
  # AppImage support
  programs.appimage = {
    enable = hostProfile.isWorkstation;
    binfmt = true;
  };
}
