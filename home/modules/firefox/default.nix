{
  lib,
  config,
  userConfig,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.firefox;
in
{

  options.modules.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.MOZ_USE_XINPUT2 = "1";
    programs.firefox = lib.mkForce {
      enable = true;

      profiles.${userConfig.username} = lib.mkForce {
        # Essential extensions only
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          privacy-badger
          link-cleaner
        ];

        settings = {
          # Core privacy settings
          "browser.send_pings" = false;
          "network.cookie.cookieBehavior" = 1;
          "privacy.resistFingerprinting" = false;
          "network.http.referer.XOriginPolicy" = 0;
          "dom.security.https_only_mode_ever_enabled" = true;
          "geo.enabled" = false;

          # Disable telemetry
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.server" = "";

          # Disable Pocket
          "extensions.pocket.enabled" = false;

          # Performance settings
          "browser.cache.disk.enable" = true;
          "browser.cache.memory.enable" = true;

          # Media and DRM (for streaming services)
          "media.eme.enabled" = true;
          "media.gmp-widevinecdm.enabled" = true;

          # UI preferences
          "browser.uidensity" = 1;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.toolbars.bookmarks.visibility" = "always";

          # Usability settings
          "browser.search.suggest.enabled" = true;
          "browser.urlbar.suggest.bookmark" = true;
          "browser.urlbar.suggest.history" = true;
          "media.autoplay.enabled" = true;
        };
      };
    };
  };
}
