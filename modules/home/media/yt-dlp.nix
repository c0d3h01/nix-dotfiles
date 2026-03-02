# Purpose: yt-dlp — YouTube downloader with sponsorblock
{
  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      --cookies-from-browser firefox
      --sponsorblock-remove all
    '';
  };
}
