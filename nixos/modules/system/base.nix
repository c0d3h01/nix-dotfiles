{
  lib,
  userConfig,
  hostName,
  ...
}:

{
  # Set hostname
  networking.hostName = userConfig.hostname;

  # System state version
  system.stateVersion = lib.trivial.release;

  # Enable sudo for wheel group
  security.sudo.wheelNeedsPassword = false;

  # Zsh program enabled as default user
  programs.zsh.enable = true;

  # Create the main user
  users.users.${userConfig.username} = {
    uid = lib.mkDefault 1000;
    isNormalUser = true;
    description = userConfig.fullName;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [
      "wheel"
      "nix"
      "networkmanager"
      "systemd-journal"
      "audio"
      "pipewire"
      "video"
      "render"
      "input"
      "plugdev"
      "lp"
      "tss"
      "power"
      "wireshark"
      "mysql"
      "cloudflared"
      "libvirtd"
      "kvm"
    ];
  };
}
