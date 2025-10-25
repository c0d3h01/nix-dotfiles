{
  pkgs,
  lib,
  userConfig,
  ...
}:
{
  config = lib.mkIf userConfig.machineConfig.workstation.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    environment.systemPackages = with pkgs; [
      code-cursor
      ghostty
      vscode-fhs
      postman
      github-desktop
      drawio
      slack
      discord-ptb
      telegram-desktop
      zoom-us
      libreoffice
      obsidian
      anydesk
      arduino
    ];
  };
}
