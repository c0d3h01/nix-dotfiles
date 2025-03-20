{ pkgs, username, ... }:

{
  imports = [
    ./apps
    ./tweaks
    ./user
    ./hardware.nix
  ];

  age.identityPaths = [ "/home/${username}/dotfiles/secrets/keys/default.key" ];

  # -*-[ Bootloader Configuration ]-*-
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Hardware acceleration for video rendering
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # -*-[ GPG ]-*-
  # Some programs need SUID wrappers, can be configured further or are
  # programs.mtr.enable = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = false;

  # -*-[ SSH ]-*-
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = true;
      AllowUsers = [ "${username}" ];
    };
  };

  # -*-[ Systemd logs ]-*-
  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
      SystemMaxFiles=10
    '';
    rateLimitBurst = 2000;
    rateLimitInterval = "60s";
  };
}
