{
  lib,
  userConfig,
  pkgs,
  ...
}:

{
  home.sessionVariables.MOZ_USE_XINPUT2 = "1";
  programs.firefox = {
    enable = true;

    profiles.${userConfig.username} = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
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
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.compactmode.show" = true;

        # Smooth scrolling
        "general.smoothScroll" = true;

        # Animation settings
        "toolkit.cosmeticAnimations.enabled" = true;
      };
    };
  };
}
