{
  config,
  pkgs,
  lib,
  userConfig,
  ...
}:

let
  python-packages = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      pyquery
    ]
  );
in
{
  ###### Hyprland Base Programs ######
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    # Basics
    killall

    # Hyprland Ecosystem
    hyprland
    waybar
    dunst
    wofi
    swaylock-effects
    grim
    slurp
    swappy
    swww
    wl-clipboard
    cliphist
    wlogout

    # Audio & Controls
    pamixer
    pavucontrol
    brightnessctl
    playerctl

    # Network & Polkit
    networkmanagerapplet
    kdePackages.polkit-kde-agent-1

    # File Management
    xfce.thunar
    xfce.tumbler

    # Python scripts
    python-packages

    # Portals
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  ###### Wayland Portals ######
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  ###### System Services ######
  services = {
    # Login Manager (Greetd + Tuigreet)
    greetd = {
      enable = true;
      vt = 3;
      settings.default_session = {
        user = userConfig.username;
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
    };

    # Useful Daemons
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    udev.enable = true;
    envfs.enable = true;
    libinput.enable = true;
    fwupd.enable = true;
    upower.enable = true;
    blueman.enable = true;
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;

    # Disable unused stuff
    xserver.enable = false;
    rpcbind.enable = false;
    nfs.server.enable = false;
    smartd = {
      enable = false;
      autodetect = true;
    };
  };

  ###### Security & Polkit ######
  security = {
    pam.services.swaylock.text = ''
      auth include login
    '';
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users") &&
            (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          ) {
            return polkit.Result.YES;
          }
        })
      '';
    };
    rtkit.enable = true;
  };

  ###### AMD GPU Drivers (Optional) ######
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.extraPackages = with pkgs; [
    libva
    libva-utils
  ];

  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

  ###### Optional Programs ######
  programs.dconf.enable = true;

  ###### Locale / Keyboard ######
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
