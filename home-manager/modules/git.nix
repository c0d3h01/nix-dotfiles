{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    git
    git-lfs
    delta
    lazygit
    mergiraf
  ];
}
