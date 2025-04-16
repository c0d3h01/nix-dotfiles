{ userConfig, ... }:
{
  home-manager.users.${userConfig.username} = {
    home.file = {
      ".config/electron-flags.conf".source = ./config/electron-flags.conf;
    };
  };
}
