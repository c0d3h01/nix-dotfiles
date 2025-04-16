{
  userConfig,
  ...
}:
{
  home-manager.users.${userConfig.username} = _: {
    home.file = {
      ".config/hypr/hyprlock.conf".source = ./config/hyprlock.conf;
    };
  };
}
