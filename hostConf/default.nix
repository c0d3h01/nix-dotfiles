{
  # Laptop machine
  laptop = {
    username = "c0d3h01";
    hostname = "neo";
    email = "harshalsawant.dev@gmail.com";
    fullName = "Harshal Sawant";
    system = "x86_64-linux";

    machine = {
      type = "laptop";
      hasGUI = true;
      bootloader = "systemd"; # Options = "systemd" | "grub"
      gpuType = "amd";
      hasBattery = true;
      gaming = false;
    };

    desktop = {
      theme = "dark";
      windowManager = "gnome";
    };

    dev = {
      ollama = true;
      tabby = false;
      phpadmin = true;
      wine = false;
      container = "podman";
      db = true;
      defaultEditor = "nvim";
      shell = "zsh";
      terminalFont = "JetBrains Mono";
    };
  };
}
