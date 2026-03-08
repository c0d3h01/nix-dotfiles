{
  programs.chromium = {
    enable = true;

    commandLineArgs = [
      "--enable-logging=stderr"
      "--ignore-gpu-blocklist"
      "--oauth2-client-id=77185425430.apps.googleusercontent.com"
      "--oauth2-client-secret=OTJgUOQcT7lO7GsGZq2G4IlT"
    ];

    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
    ];
  };
}
