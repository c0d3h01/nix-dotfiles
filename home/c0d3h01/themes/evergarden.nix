{ inputs, ... }:
{
  imports = [ inputs.evergarden.homeManagerModules.default ];

  config = {
    evergarden = {
      enable = true;
      variant = "winter";
      accent = "red";
      alacritty.enable = false;
      cache.enable = true;
    };
  };
}
