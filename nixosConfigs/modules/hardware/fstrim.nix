{
  # Scheduled fstrim
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
