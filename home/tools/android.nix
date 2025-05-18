{
  config,
  lib,
  pkgs,
  ...
}:

let
  androidenv = pkgs.androidenv.override { licenseAccepted = true; };
  androidSdk =
    (androidenv.composeAndroidPackages {
      cmdLineToolsVersion = "8.0";
      platformToolsVersion = "35.0.2";
      buildToolsVersions = [ "30.0.3" ];
      platformVersions = [ "30" ];
      includeEmulator = false;
      includeSources = false;
      includeSystemImages = false;
      includeNDK = true;
      ndkVersions = [ "22.0.7026061" ];
      extraLicenses = [ "android-sdk-license" ];
    }).androidsdk;

  sdkRoot = "${androidSdk}/libexec/android-sdk";
  ndkVersion = "22.0.7026061";
in
{
  options.myModules.androidTools = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Android tools installation in Home Manager";
  };

  config = lib.mkIf config.myModules.androidTools {
    # home.packages = [ androidSdk ];

    home.sessionVariables = {
      ANDROID_HOME = sdkRoot;
      ANDROID_SDK_ROOT = sdkRoot;
      ANDROID_NDK_ROOT = "${sdkRoot}/ndk/${ndkVersion}";
    };

    home.sessionPath = [
      "${sdkRoot}/ndk/${ndkVersion}"
      "${sdkRoot}/platform-tools"
      "${sdkRoot}/cmdline-tools/latest/bin"
      "${sdkRoot}/build-tools/30.0.3"
    ];
  };
}
