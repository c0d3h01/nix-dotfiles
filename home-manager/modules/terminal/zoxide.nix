{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [
      "--no-cmd"
    ];
  };
}
