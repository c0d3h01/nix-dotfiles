{pkgs, ...}: {
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
    package = pkgs.scx.rustscheds;
  };
}
