{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault getExe';
in
{
  security.sudo = {
    enable = true;

    # wheelNeedsPassword = false means wheel group can execute commands without a password
    wheelNeedsPassword = mkDefault false;

    # only allow members of the wheel group to execute sudo
    execWheelOnly = true;

    extraRules = [
      {
        groups = [ "wheel" ];

        commands = [
          # nixos-rebuild work without password
          {
            command = getExe' pkgs.nixos-rebuild "nixos-rebuild";
            options = [ "NOPASSWD" ];
          }

          # allow reboot and shutdown without password
          {
            command = getExe' pkgs.systemd "systemctl";
            options = [ "NOPASSWD" ];
          }
          {
            command = getExe' pkgs.systemd "reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = getExe' pkgs.systemd "shutdown";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
