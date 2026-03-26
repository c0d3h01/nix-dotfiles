{hostProfile, ...}: {
  services.upower = {
    enable = hostProfile.isWorkstation;
    percentageLow = 25;
    percentageCritical = 20;
    percentageAction = 15;
    criticalPowerAction = "Hibernate";
  };
}
