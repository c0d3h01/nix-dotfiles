{
  lib,
  pkgs,
  config,
  ...
}: {
  # Listen for hardware events (lid close, power button)
  services.acpid.enable = true;

  environment.systemPackages = with pkgs; [
    acpi # CLI tool to check battery/thermal status
    powertop # Real-time power consumption analyzer and tuner
  ];

  boot = {
    # Load acpi_call for custom ACPI method execution (e.g., battery thresholds)
    kernelModules = ["acpi_call"];

    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
  };

  # Auto-suspend USB devices to save power
  powerManagement.powertop.enable = true;
}
