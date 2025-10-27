{
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git"
      "*.bak"
      ".direnv"
    ];
    extraOptions = [
      "--no-ignore"
      "--absolute-path"
    ];
  };
}


