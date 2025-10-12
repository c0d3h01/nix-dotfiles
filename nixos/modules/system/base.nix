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

  # Create the main user
  users.users.${userConfig.username} = {
    uid = mkDefault 1000;
    isNormalUser = true;
    description = userConfig.fullName;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "pipewire"
      "video"
      "wireshark"
      "mysql"
      "libvirtd"
      "kvm"
    ];
  };
}
