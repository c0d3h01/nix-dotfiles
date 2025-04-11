{ lib
, pkgs
, config
, ...
}: {

  # Remove greetd since using GDM from GNOME
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
  #       user = "greeter";
  #     };
  #   };
  # };

  # Enable the gnome-keyring secrets vault
  services.gnome.gnome-keyring.enable = true;

  # Enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      waybar
      wofi
      swaybg
      grim
      slurp
      wf-recorder
      clipman
      brightnessctl
      pamixer
      networkmanagerapplet
      blueman
      poweralertd
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {

      modifier = "Mod4";
      terminal = "kitty";
      menu = "wofi --show drun";
      browser = "firefox";
      editor = "nvim";

      # Keybindings
      keybindings = lib.mkOptionDefault {
        # Basic keybindings
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        # Workspace navigation
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";

        # Layout
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        # System
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Do you want to exit sway?' -b 'Yes' 'swaymsg exit'";

        # Media controls
        "XF86AudioRaiseVolume" = "exec --no-startup-id pamixer -i 5";
        "XF86AudioLowerVolume" = "exec --no-startup-id pamixer -d 5";
        "XF86AudioMute" = "exec --no-startup-id pamixer -t";
        "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
        "XF86AudioNext" = "exec --no-startup-id playerctl next";
        "XF86AudioPrev" = "exec --no-startup-id playerctl previous";

        # Brightness
        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";

        # Screenshot
        "Print" = "exec --no-startup-id grim -g \"$(slurp)\" - | wl-copy";
        "${modifier}+Print" = "exec --no-startup-id grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d-%H-%M-%S).png";
      };

      # Input configuration
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "";
          repeat_delay = "300";
          repeat_rate = "50";
        };

        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          click_method = "clickfinger";
          scroll_method = "two_finger";
          drag = "enabled";
          drag_lock = "enabled";
        };
      };

      # Output configuration
      output = {
        "*" = {
          bg = "~/.config/sway/wallpaper.png fill";
        };
      };

      # Startup applications
      startup = [
        { command = "firefox"; }
        { command = "waybar"; }
        { command = "mako"; }
        { command = "swaybg -i ~/.config/sway/wallpaper.png"; }
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
        { command = "poweralertd"; }
      ];

      # Window rules
      window = {
        border = 2;
        titlebar = false;
        hide_edge_borders = "smart";
      };

      # Gaps
      gaps = {
        inner = 10;
        outer = 5;
        smart_gaps = true;
      };

      # Colors
      colors = {
        focused = {
          border = "#89b4fa";
          background = "#89b4fa";
          text = "#1e1e2e";
          indicator = "#89b4fa";
          childBorder = "#89b4fa";
        };
        focusedInactive = {
          border = "#313244";
          background = "#313244";
          text = "#cdd6f4";
          indicator = "#313244";
          childBorder = "#313244";
        };
        unfocused = {
          border = "#313244";
          background = "#313244";
          text = "#cdd6f4";
          indicator = "#313244";
          childBorder = "#313244";
        };
        urgent = {
          border = "#f38ba8";
          background = "#f38ba8";
          text = "#1e1e2e";
          indicator = "#f38ba8";
          childBorder = "#f38ba8";
        };
      };
    };
  };

  # Enable polkit for authentication
  security.polkit.enable = true;
}
