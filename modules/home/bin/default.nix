{
  home.file = {
    "bin/archinstall.sh" = {
      source = ./archinstall.sh;
      executable = true;
    };

    "bin/postinstall.sh" = {
      source = ./postinstall.sh;
      executable = true;
    };

    "bin/wifi-manager.sh" = {
      source = ./wifi-manager.sh;
      executable = true;
    };
  };
}
