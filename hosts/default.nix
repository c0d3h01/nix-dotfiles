{
  laptop = {
    system = "x86_64-linux";
    modules = [./laptop];

    users.c0d3h01 = {
      isMainUser = true;
      fullName = "Harshal Sawant";
      workstation = true;
      windowManager = "gnome";
    };

    users.lara = {
      fullName = "Lara";
      workstation = true;
      windowManager = "gnome";
    };

    bootloader = "limine";
  };
}
