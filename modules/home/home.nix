{config, ...}: {
  home = {
    username = "c0d3h01";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.11";
    enableNixpkgsReleaseCheck = false;
  };
}
