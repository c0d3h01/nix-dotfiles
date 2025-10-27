{
  userConfig,
  lib,
  ...
}:

{
  imports = [
    ./tools
    ./editors
    ./programs
    ./system
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  manual.manpages.enable = false;
  programs.man.enable = lib.mkDefault false;

  home = {
    inherit (userConfig) username;
    shell.enableShellIntegration = false;
    shell.enableIonIntegration = true;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = lib.trivial.release;
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "google-chrome";
      TERMINAL = "alacritty";
    };
  };
}
