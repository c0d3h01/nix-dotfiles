{ config, userConfig, ... }:

{
  xdg.configFile = {
    "ags" = {
      source = ./ags;
      recursive = true;
      force = true;
    };

    "fastfetch" = {
      source = ./fastfetch;
      recursive = true;
      force = true;
    };

    "hypr" = {
      source = ./hypr;
      recursive = true;
      force = true;
    };

    "kvantum" = {
      source = ./Kvantum;
      recursive = true;
      force = true;
    };

    "qt5ct" = {
      source = ./qt5ct;
      recursive = true;
      force = true;
    };

    "qt6ct" = {
      source = ./qt6ct;
      recursive = true;
      force = true;
    };

    "rofi" = {
      source = ./rofi;
      recursive = true;
      force = true;
    };

    "swappy" = {
      source = ./swappy;
      recursive = true;
      force = true;
    };

    "swaync" = {
      source = ./swaync;
      recursive = true;
      force = true;
    };

    "wallust" = {
      source = ./wallust;
      recursive = true;
      force = true;
    };

    "wlogout" = {
      source = ./wlogout;
      recursive = true;
      force = true;
    };

    "waybar" = {
      source = ./waybar;
      recursive = true;
      force = true;
    };
  };
}
