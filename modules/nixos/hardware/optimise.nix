{
  config,
  lib,
  hostProfile,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf hostProfile.isWorkstation {
    services = {
      # Dynamically tunes kernel BPF parameters for network and latency optimization
      bpftune.enable = true;

      # Distributes hardware interrupts across CPU cores to reduce latency spikes
      irqbalance.enable = true;

      upower = {
        enable = true;
        percentageLow = 25; # Warn user when battery drops below 25%
        percentageCritical = 20; # Trigger critical warning at 20%
        percentageAction = 15; # Execute action when battery hits 15%
        criticalPowerAction = "Hibernate"; # Hibernate system at 15% battery
      };

      scx = {
        # Enable SCX only on workstations; disabled on servers
        enable = true;

        # scx_lavd: Latency-critical, adaptive scheduler for desktops
        scheduler = "scx_lavd";

        extraArgs = [
          # Balance latency and power; avoids constant max freq heat spikes
          "--interactive"
          # Limit active cores under light load to save power/heat
          "--active_core_ratio"
          "0.75"
          # Disable frequency scaling within scheduler (let CPU governor handle it)
          "--no_freq_scale"
        ];
      };
    };
  };
}
