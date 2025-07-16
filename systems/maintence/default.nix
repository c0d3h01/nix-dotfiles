{
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko

    ../c0d3h01/disko-btrfs.nix
    ./users.nix
  ];

  garden = {
    # Gnome Environment
    programs.gnome.enable = true;

    profiles = {
      laptop.enable = true;
      graphical.enable = false;
      workstation.enable = false;
    };

    device = {
      cpu = "amd";
      gpu = "amd";
      keyboard = "us";
      capabilities = {
        tpm = true;
        bluetooth = false;
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
      printing.enable = false;

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
