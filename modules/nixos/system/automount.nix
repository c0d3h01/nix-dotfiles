{
  lib,
  userConfig,
  ...
}: {
  # Enable polkit rules only if GUI is available
  security.polkit.extraConfig = lib.mkIf userConfig.workstation ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0 &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';
}
