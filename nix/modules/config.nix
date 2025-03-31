{ config
, username
, pkgs
, ...
}:
{
  programs = {
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = false;
  };

  services = {
    # SSH support
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
        AllowUsers = [ "${username}" ];
      };
    };
    # Printing support
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint hplip ];
    };
    avahi = {
      enable = true;
      openFirewall = true;
    };
  };

  services.ananicy = {
    enable = true;
    settings = {
      apply_nice = true;
      check_freq = 10; # runs every seconds
      cgroup_load = true;
      type_load = true;
      rule_load = true;
      apply_ioclass = true;
      apply_ionice = true;
      apply_sched = true;
      apply_oom_score_adj = true;
      apply_cgroup = true;
      check_disks_schedulers = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 200;
    priority = 100;
  };
}
