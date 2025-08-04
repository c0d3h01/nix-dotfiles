{
  lib,
  config,
  userConfig,
  ...
}:

{
  # enable opportunistic TCP encryption
  # this is NOT a pancea, however, if the receiver supports encryption and the attacker is passive
  # privacy will be more plausible (but not guaranteed, unlike what the option docs suggest)
  networking.tcpcrypt.enable = userConfig.machine.type == "server";

  users = lib.mkIf config.networking.tcpcrypt.enable {
    groups.tcpcryptd = { };
    users.tcpcryptd = {
      group = "tcpcryptd";
      isSystemUser = true;
    };
  };
}
