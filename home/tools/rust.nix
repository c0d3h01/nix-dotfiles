{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.myModules.rustTools = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Install Rust development tools for the user";
  };

  config = lib.mkIf config.myModules.rustTools {
    home.packages = with pkgs; [
      rustup
      rustfmt
      rust-analyzer
    ];
  };
}
