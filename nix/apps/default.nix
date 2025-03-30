{ config
, pkgs
, lib
, ...
}:
{
  imports = [ ./devtools ];

  # Flatpak apps support
  # services.flatpak.enable = true;

  # VirtualMachine
  # virtualisation.libvirtd.enable = true;
  # users.users.${username}.extraGroups = [ "libvirtd" ];

  # Allow running dynamically linked binaries
  programs.nix-ld.enable = true;

  # Environment packages
  environment.systemPackages =
    let
      devTools = with pkgs; [
        # Editors and IDEs
        vscode-fhs
        jetbrains.webstorm

        # JavaScript/TypeScript
        nodejs

        # C/C++
        gcc
        gdb
        clang
        gnumake
        cmake
        ninja

        # GTK development tools
        gtk3
        gtk4
        pkg-config

        # API Development
        postman
      ];

      utilityApps = with pkgs; [
      ];

      communicationApps = with pkgs; [
        discord
        telegram-desktop
        slack
        zoom-us
      ];

      desktopApps = with pkgs; [
        # Custom patched Notion
        (pkgs.callPackage ./notion-app-enhanced { })
        spotify
        anydesk
        github-desktop
        chromium
      ];

      androidTools = with pkgs; [
        android-studio
        flutter
        openjdk
        gradle
      ];
    in
    utilityApps ++ devTools ++ communicationApps ++ desktopApps ++ androidTools;
}
