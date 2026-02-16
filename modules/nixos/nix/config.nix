{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    allowInsecure = false;
    allowUnsupportedSystem = false;
    permittedInsecurePackages = [
      "librewolf-bin-147.0.2-1"
      "librewolf-bin-unwrapped-147.0.2-1"
    ];
  };
}
