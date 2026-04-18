{
  config,
  ...
}: {
  home = {
    username = "${config.home.username}";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.11";
    enableNixpkgsReleaseCheck = false;
  };
}
