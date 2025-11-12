{
  nixpkgs = {
    config = {
      # Unfree: allowed
      allowUnfree = true;

      # Narrow unfree scope.
      # allowUnfreePredicate = pkg: builtins.elem (pkg.pname or pkg.name) [
      #   "google-chrome"
      #   "steam"
      #   "nvidia-x11"
      # ];

      # DO NOT allow all insecure packages globally.
      allowInsecure = false;

      # Explicit, reviewed insecure exceptions (keep minimal, annotate).
      # Each entry should match the exact attribute's name (see evaluation error messages).
      permittedInsecurePackages = [
        "openssl-1.1.1u"
      ];

      android_sdk.accept_license = true;

      # Usually leave false; enabling hides unsupported attrpaths that may break differently.
      allowUnsupportedSystem = true;
    };
  };
}
