{ config, ... }:
{
  # have polkit log all actions
  security = {
    polkit.enable = true;

    # # this should only be installed on graphical systems
    # soteria.enable =
    #   config.garden.profiles.graphical.enable && !config.services.desktopManager.cosmic.enable;
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.udisks2.filesystem-mount") == 0 &&
            subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    });
  '';
}
