{
  config,
  pkgs,
  userConfig,
  ...
}:
{
  imports = [
    ./electron.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./xdg.nix
  ];

  home-manager.users.${userConfig.username} = _: {
    home.file = {
      ".scripts/autostart.sh" = {
        source = ./autostart.sh;
        executable = true;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      brightnessctl
      grim
      gthumb
      hyprpanel
      hyprpaper
      libnotify
      nemo-with-extensions
      networkmanagerapplet
      pavucontrol
      playerctl
      pywal
      slurp
      wl-clipboard
      zenity
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.uwsm = {
    enable = true;
  };

  programs.hyprlock = {
    enable = true;
  };

  programs.dconf.enable = true;
}
