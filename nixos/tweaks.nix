{ config, lib, ... }:

{
  services.power-profiles-daemon.enable = false;
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  # powerManagement.cpuFreqGovernor = "ondemand";
  services.auto-cpufreq.enable = true;
}
