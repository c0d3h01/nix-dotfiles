{
  # prevent conflict
  services.power-profiles-daemon.enable = false;

  # auto-cpufreq service
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "auto";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
