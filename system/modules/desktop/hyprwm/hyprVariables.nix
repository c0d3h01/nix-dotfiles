{
  monitorSetup = {
    Desktop = ''
      # ---- Desktop-specific Monitor Setup ---- #
      monitor = DP-1, 1920x1080@180, 0x0, 1
      monitor = HDMI-A-2, 1920x1080, 1920x0, 1

      workspace = 1,  monitor:DP-1, default:true
      workspace = 2,  monitor:HDMI-A-2, default:true
      workspace = 3,  monitor:DP-1
      workspace = 4,  monitor:DP-1
      workspace = 5,  monitor:DP-1
      workspace = 6,  monitor:DP-1
      workspace = 7,  monitor:DP-1
      workspace = 8,  monitor:DP-1
      workspace = 9,  monitor:HDMI-A-2
      workspace = 10, monitor:HDMI-A-2
    '';
    Laptop = ''
      # ---- Laptop-specific Monitor Setup ---- #
      monitor =   eDP-1, 1920x1080, 0x0, 1
      monitor = , preferred, auto, 1
    '';
  };
  WindowRules = {
    Desktop = ''
      # General layout rule for workspace 2
      workspace    = 2,split:v
      windowrulev2 = workspace 2 silent, class:^(discord)$
      windowrulev2 = tile, class:^(discord)$
      windowrulev2 = workspace 2 silent, title:^(Spotify Premium)$
      windowrulev2 = tile, title:^(Spotify Premium)$

      # General layout rule for workspace 7
      windowrulev2 = workspace 7 silent, class:^(steam)$
    '';
    Laptop = '''';
  };
}
