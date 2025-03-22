{ config, pkgs, username, ... }:

let
  androidenv = pkgs.androidenv;
  androidSdk = (androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "8.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "35.0.2";
    buildToolsVersions = [ "30.0.3" ];
    includeEmulator = false;
    emulatorVersion = "30.3.4";
    platformVersions = [ "28" "29" "30" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
    ndkVersions = [ "22.0.7026061" ];
  }).androidsdk;
in
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.variables = {
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    ANDROID_NDK_ROOT = "${androidSdk}/libexec/android-sdk/ndk/22.0.7026061";
    ANDROID_NDK_HOME = "${androidSdk}/libexec/android-sdk/ndk/22.0.7026061";
  };

  environment.systemPackages = with pkgs; [
    universal-android-debloater # uad-ng
    android-studio
    flutter
    androidSdk
  ];

  environment.extraInit = ''
    export PATH="${androidSdk}/libexec/android-sdk/ndk/22.0.7026061:$PATH"
    export PATH="${androidSdk}/libexec/android-sdk/platform-tools:$PATH"
  '';
}
