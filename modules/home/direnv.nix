{
  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;

    direnvrcExtra = ''
      warn_timeout=0
      hide_env_diff=true
    '';
  };
}
