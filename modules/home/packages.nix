{pkgs, ...}: {
  home.packages = with pkgs; [
    gh
    gemini-cli
  ];
}
