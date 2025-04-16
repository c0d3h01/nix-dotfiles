{
  userConfig,
  ...
}:
{
  home-manager.users.${userConfig.username} = _: {
    home.file = {
      ".config/hypr/hyprpaper.conf".source = ./config/hyprpaper.conf;
    };
  };
}
