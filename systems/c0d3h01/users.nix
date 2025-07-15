{
  garden.system = {
    mainUser = "c0d3h01";
    users = [ "c0d3h01" ];
  };

  home-manager.users.c0d3h01 = {

    garden.programs.defaults = {
      shell = "zsh";
      browser = "firefox";
    };

    programs = {
      git.signing.key = "3E7C7A1B5DEDBB03";

      # browser
      firefox.enable = true;
      chromium.enable = true;

      # Shells
      zsh.enable = true;
      # fish.enable = true;

      # Desk Apps
      discord.enable = true;
      ghostty.enable = true;
    };
  };
}
