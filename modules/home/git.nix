{
  pkgs,
  lib,
  ...
}: let
  gpgBin = "${pkgs.gnupg}/bin/gpg";
in {
  home.packages = with pkgs; [
    gnupg
    pinentry-curses
  ];

  programs.gpg = {
    enable = true;

    settings = {
      # Display
      keyid-format = "0xlong";
      with-fingerprint = true;
      with-keygrip = true;
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      charset = "utf-8";

      # Crypto hardening
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-cipher-preferences = "AES256 AES192 AES";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      s2k-count = "65011712";

      # Validation
      require-cross-certification = true;
      verify-options = "show-uid-validity";
      list-options = "show-uid-validity";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;

    # pinentry-curses: works over SSH, tmux, headless TTYs
    pinentry.package = pkgs.pinentry-curses;

    # Cache TTL: 8 h default, 24 h hard max
    defaultCacheTtl = 28800; # 8 h
    maxCacheTtl = 86400; # 24 h
    defaultCacheTtlSsh = 28800;
    maxCacheTtlSsh = 86400;

    extraConfig = ''
      # Allow pinentry over loopback (needed for some terminal multiplexers)
      allow-loopback-pinentry
    '';
  };

  programs.git = {
    enable = true;

    lfs.enable = true;

    signing = {
      key = "A7A7A1725FBF10AB04BF1355B4242C21BAF74B7C";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Harshal Sawant";
        email = "harshalsawant.dev@gmail.com";
      };

      # Pin gpg binary to Nix store path
      gpg.program = gpgBin;

      # Sign tags as well
      tag.gpgSign = true;

      # Sane baseline defaults (idiomatic for a senior workflow)
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      merge.conflictStyle = "zdiff3"; # 3-way diff context in conflict markers
      diff.algorithm = "histogram";
      rerere.enabled = true; # remember & reuse conflict resolutions
      core = {
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        fsync = "committed"; # durable writes on commit
      };

      # Prevent credential leakage over HTTP
      credential.helper = "store --file ~/.git-credentials";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # Delta for human-readable diffs
  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      side-by-side = false;
      line-numbers = true;
      syntax-theme = "base16";
    };
  };

  # SSH_AUTH_SOCK → gpg-agent ssh socket
  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/gnupg/S.gpg-agent.ssh";
    # Make git always use the Nix-store gpg regardless of PATH order
    GPG_TTY = "$(tty)";
  };

  # Shell hook — sets GPG_TTY and refreshes gpg-agent in every interactive shell.
  # Works for bash, zsh, fish via HM's own shell modules; add equivalent for others.
  programs.bash.initExtra = lib.mkAfter ''
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
    ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
  '';

  programs.zsh.initContent = lib.mkAfter ''
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"
    ${pkgs.gnupg}/bin/gpgconf --launch gpg-agent
  '';
}
