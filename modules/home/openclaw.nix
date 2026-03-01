{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.home.features.openclaw;
in {
  options.dotfiles.home.features.openclaw.enable = mkEnableOption "OpenClaw";

  imports = [
    # keep-sorted start
    inputs.nix-openclaw.homeManagerModules.openclaw
    # keep-sorted end
  ];

  config = mkIf cfg.enable {
    programs.openclaw = {
      enable = true;

      # Schema-typed OpenClaw config (from upstream).
      config = {
        gateway = {
          mode = "local";
        };

        agents = {
          defaults = {
            model = {
              # Gemini via API key (GEMINI_API_KEY).
              primary = "google/gemini-3-pro-preview";
            };
          };
        };

        channels.telegram = {
          # Bot token managed via sops.
          tokenFile = config.sops.secrets.openclaw-telegram-token.path;
          # TODO: replace with your Telegram user ID (from @userinfobot).
          allowFrom = [123456];
          groups = {
            "*" = {requireMention = true;};
          };
        };
      };

      instances.default = {
        enable = true;
        plugins = [
          # { source = "github:acme/hello-world"; }
        ];
      };
    };

    # OpenClaw secrets are managed via sops-nix.
    sops.secrets = {
      openclaw-telegram-token = {};
      openclaw-env = {};
    };

    # Load API keys at runtime without storing them in the Nix store.
    systemd.user.services.openclaw-gateway = {
      Service.EnvironmentFile = [config.sops.secrets.openclaw-env.path];
    };
  };
}
