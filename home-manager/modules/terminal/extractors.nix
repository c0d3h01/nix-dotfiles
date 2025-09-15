{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # Extractors
    unzip
    unrar
    p7zip
    xz
    zstd
    cabextract
  ];
}
