{
  services.tuned = {
    enable = true;
    # ppdSettings.main.battery_detection = true;
  };

  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };
}
