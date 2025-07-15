{
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko

    ./disko-btrfs.nix
    ./users.nix
  ];

  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  garden = {
    # Gnome Environment
    programs.gnome.enable = true;

    profiles = {
      laptop.enable = true;
      graphical.enable = true;
      workstation.enable = true;
    };

    device = {
      cpu = "amd";
      gpu = "amd";
      monitors = "eDP-1";
      keyboard = "us";
      capabilities = {
        tpm = true;
      };
    };

    system = {
      boot = {
        loader = "systemd-boot";
        secureBoot = false;

        loadRecommendedModules = true;
        enableKernelTweaks = true;

        # silentBoot = false;
        # memtest.enable = false;

        initrd = {
          enableTweaks = true;
          optimizeCompressor = true;
        };
      };

      bluetooth.enable = true;
      printing.enable = true;

      security = {
        fixWebcam = false;
        auditd.enable = true;
      };

      networking = {
        optimizeTcp = true;
      };
    };
  };
}
