{
  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      --cookies-from-browser firefox
      --sponsorblock-remove all
    '';
  };
}
