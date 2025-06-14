{
  inputs,
  declarative,
  pkgs,
  lib,
  config,
  ...
}:

let
  theme = {
    flavor = "mocha"; # Options: "mocha", "macchiato", "frappe", "latte"
    accent = "mauve"; # Options: "mauve" "blue", "flamingo", "green", ...
    size = "compact"; # "standard", "compact"
  };

  catppuccinGtkTheme = inputs.catppuccin.packages.${pkgs.system}.gtk.override {
    flavor = theme.flavor;
    accents = [ theme.accent ];
    size = theme.size;
    tweaks = [ "rimless" ];
  };

in
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin.tty = {
    enable = true;
    flavor = theme.flavor;
  };

  catppuccin.grub = {
    enable = true;
    flavor = theme.flavor;
  };

  # Home Manager user config
  home-manager.users.${declarative.username} =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      # GTK theming
      gtk = {
        enable = true;
        theme = {
          name = catppuccinGtkTheme.name;
          package = catppuccinGtkTheme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Bibata-Modern-Ice";
          package = pkgs.bibata-cursors;
          size = 24;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      # Catppuccin configs
      catppuccin = {
        brave = {
          enable = true;
          flavor = theme.flavor;
        };
        obs = {
          enable = true;
          flavor = theme.flavor;
        };
        starship = {
          enable = true;
          flavor = theme.flavor;
        };
        micro = {
          enable = true;
          flavor = theme.flavor;
          transparent = true;
        };
        zellij = {
          enable = true;
          flavor = theme.flavor;
        };
      };
    };
}
