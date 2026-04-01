{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  environment.systemPackages = with pkgs; [
    gspell # gtk spellchecker
    fcitx5
    fcitx5-gtk
    qt6Packages.fcitx5-configtool
    hunspell
  ];
}
