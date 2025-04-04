{ pkgs
, user
, ...
}: {
  imports = [ ./modules ];

  modules.firefox.enable = true;
  home = {
    username = "${user.username}";
    homeDirectory = "/home/${user.username}";
    stateVersion = "24.11";

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
      age
      openssh

      # Utilities
      fastfetch
      glances
      tmux
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

    bat = {
      enable = true;
      config.theme = "OneHalfDark";
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--pretty"
      ];
    };

    eza = {
      enable = true;
      extraOptions = [
        "--classify"
        "--color-scale"
        "--git"
        "--group-directories-first"
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    git.difftastic = {
      enable = true;
      background = "dark";
      display = "inline";
    };

    htop = {
      enable = true;
      settings =
        {
          tree_view = 1;
          hide_kernel_threads = 1;
          hide_userland_threads = 1;
          shadow_other_users = 1;
          show_thread_names = 1;
          show_program_path = 0;
          highlight_base_name = 1;
          header_layout = "two_67_33";
          color_scheme = 6;
        }
        // (with config.lib.htop; leftMeters [ (bar "AllCPUs4") ])
        // (
          with config.lib.htop;
          rightMeters [
            (bar "Memory")
            (bar "Swap")
            (bar "DiskIO")
            (bar "NetworkIO")
            (text "Systemd")
            (text "Tasks")
            (text "LoadAverage")
          ]
        );
    };
  };
}
