{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    myModules.rustTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install Rust modules";
    };
  };

  config = lib.mkIf config.myModules.rustTools {

    environment.systemPackages = with pkgs; [
      rustup
      rustfmt
      rust-analyzer
    ];
    programs.zsh.shellInit = ''
      export RUSTUP_HOME="$HOME/.rustup"
      export CARGO_HOME="$HOME/.cargo"
    '';
  };
}
