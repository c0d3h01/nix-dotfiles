{config, ...}: {
  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gnupg";
  };
}
