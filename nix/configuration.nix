{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./apps
    ./c0d3h01
    ./hardware.nix
    ./optimization.nix
  ];

  # Nix System configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      max-jobs = lib.mkDefault 8;
    };
    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1d";
    };
  };

  # -*-[ Bootloader Configuration ]-*-
  boot = {
    tmp.cleanOnBoot = true;
    # kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      #systemd-boot.enable = true;
       grub = {
         enable = true;
         device = "nodev";
         efiSupport = true;
         useOSProber = true;
       };
      efi.canTouchEfiVariables = true;
    };
  };


  # Hardware acceleration for video rendering
  hardware.graphics = {
    enable32Bit = true;
  };

  # -*-[ GPG ]-*-
  # Some programs need SUID wrappers, can be configured further or are
  # programs.mtr.enable = true;
  programs = {
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = false;
  };

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
}
