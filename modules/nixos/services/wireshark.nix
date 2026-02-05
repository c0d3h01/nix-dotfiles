{
  pkgs,
  userConfig,
  ...
}: {
  users.users.${userConfig.username}.extraGroups = [ "wireshark" ];
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    usbmon.enable = true;
  };
}
