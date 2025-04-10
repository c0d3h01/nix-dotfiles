{ pkgs
, user
, ... }: {

  imports = [ ./modules ];

  modules.firefox.enable = true;
  home = {
    username = "${user.username}";
    homeDirectory = "/home/${user.username}";
    stateVersion = "${user.stateVersion}";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      BROWSER = "firefox";
      PAGER = "less";
      LESS = "-R";

      # ANDROID_HOME = "/home/c0d3h01/Android";
      # ANDROID_SDK_ROOT = "/home/c0d3h01/Android";
      # ANDROID_NDK_HOME = "/home/c0d3h01/Android/android-ndk-r27c";
      # PATH = "$HOME/Android/cmdline-tools/bin:$HOME/Android/platform-tools:$HOME/Android/android-ndk-r27c:$PATH";
      CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
    };

    sessionPath = [
      "$HOME/.npm-global/bin"
    ];

    packages = with pkgs; [
      home-manager

      # Utilities
      fastfetch
      glances
      xclip
      curl
      wget
      tree
      asar
      fuse
      dos2unix
      appimage-run
      wine # Windows
      ventoy
      shc # Shell compiler
      nh # Nix Garbage Cleaner
      rsync

      # Editors & Viewers
      fd # find
      dust # Disk usage visualization

      # Nix Tools
      nix-prefetch-github

      # Language Servers
      lua-language-server
      nil

      # System Monitoring
      inxi
      procs

      # Diffing
      diff-so-fancy

      # Extractors
      unzip
      unrar
      p7zip
      xz
      zstd
      cabextract
    ];
  };

  programs = {
    zoxide.enable = true;

    zellij = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;

      settings = {
        theme = "one-half-dark";
        themes.one-half-dark = {
          bg = [
            40
            44
            52
          ];
          gray = [
            40
            44
            52
          ];
          red = [
            227
            63
            76
          ];
          green = [
            152
            195
            121
          ];
          yellow = [
            229
            192
            123
          ];
          blue = [
            97
            175
            239
          ];
          magenta = [
            198
            120
            221
          ];
          orange = [
            216
            133
            76
          ];
          fg = [
            220
            223
            228
          ];
          cyan = [
            86
            182
            194
          ];
          black = [
            27
            29
            35
          ];
          white = [
            233
            225
            254
          ];
        };
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "c0d3h01" = {
          hostname = "c0d3h01";
          user = "root";
          forwardAgent = true;
        };
      };
    };

    micro = {
      enable = true;
      settings = {
        clipboard = "internal";
        colorscheme = "one-dark";
        diffgutter = true;
        indentchar = "space";
        scrollbar = true;
      };
    };
  };
}
