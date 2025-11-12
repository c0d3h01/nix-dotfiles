{
  lib,
  userConfig,
  hostName,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  # Set hostname
  networking.hostName = userConfig.hostname;

  # System state version
  system.stateVersion = lib.trivial.release;

  # Enable sudo for wheel group
  security.sudo.wheelNeedsPassword = false;

  # Zsh program enabled as default user
  programs.zsh.enable = true;

  # configure a setcap wrapper
  programs.mtr.enable = true;

  # Install browser for usr.
  programs.firefox.enable = true;

  # Image/video preview
  services.tumbler.enable = true;

  # Mounting USB & More
  services.gvfs.enable = true;

  # smartd daemon from smartmontools package
  services.smartd = {
    enable = true;
    autodetect = true;
  };

  # Create the main user
  users.users.${userConfig.username} = {
    uid = mkDefault 1000;
    isNormalUser = true;
    description = userConfig.fullName;

    # z - shell default for users
    shell = "/run/current-system/sw/bin/zsh";

    # only add groups that exist
    extraGroups = [
      "wheel"
      "nix"
      "networkmanager"
      "systemd-journal"
      "audio"
      "pipewire"
      "video"
      "input"
      "plugdev"
      "power"
    ];
  };
}
