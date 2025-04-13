{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    rustup
  ];
  programs.zsh.shellInit = ''
    export RUSTUP_HOME="$HOME/.rustup"
    export CARGO_HOME="$HOME/.cargo"
  '';
}
