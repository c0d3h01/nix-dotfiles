{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    allowInsecure = false;
    allowUnsupportedSystem = false;
    android_sdk.accept_license = true;
    permittedInsecurePackages = [
      "librewolf-bin-147.0.1-3"
      "librewolf-bin-unwrapped-147.0.1-3"
    ];
  };
}
