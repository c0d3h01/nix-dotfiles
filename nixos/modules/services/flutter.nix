{
  config,
  lib,
  pkgs,
  userConfig,
  ...
}:
let
  inherit (userConfig.devStack) flutterdevEnable;
in
{
  config = lib.mkIf flutterdevEnable {
    # Allow unfree packages for Flutter development
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "flutter"
        "android-studio"
      ];

    # Install Flutter development packages
    environment.systemPackages = with pkgs; [
      flutter # Flutter SDK
      android-studio # Android Studio IDE
      androidenv.androidPkgs.platform-tools # This includes adb
      androidenv.androidPkgs.emulator # For Android emulator
      androidenv.androidPkgs.ndk-bundle # Android NDK
      jdk # Java Development Kit
    ];

    # Enable ADB (Android Debug Bridge) at system level
    programs.adb.enable = true;

    # Add user to adbusers group automatically
    users.users.${userConfig.username}.extraGroups = [ "adbusers" ];
  };
}
