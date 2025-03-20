{ lib, config, username, pkgs, ... }:
with lib;
let
  cfg = config.modules.firefox;
in
{
  options.modules.firefox = { enable = mkEnableOption "firefox"; };

  config = mkIf cfg.enable {
    programs.firefox = lib.mkForce {
      enable = true;

      profiles.${username} = {
        # Essential extensions only
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          darkreader
        ];

        settings = {
          # Font configuration
          "font.default.x-western" = "sans-serif";
          "font.name.serif.x-western" = "Source Serif Pro";
          "font.name.sans-serif.x-western" = "Inter";
          "font.name.monospace.x-western" = "Fira Code";
          "font.name-list.emoji" = "Noto Color Emoji";

          # Font rendering
          "gfx.font_rendering.cleartype_params.rendering_mode" = 5;
          "gfx.font_rendering.cleartype_params.smoothing" = 2;

          # Core privacy settings
          "browser.send_pings" = false;
          "network.cookie.cookieBehavior" = 3;
          "network.http.referer.XOriginPolicy" = 1;
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
          "media.autoplay.enabled" = false;
        };

        # UserChrome CSS for consistent theming
        userChrome = "
          * { 
              box-shadow: none !important;
              border: 0px solid !important;
          }

          #tabbrowser-tabs {
              --user-tab-rounding: 8px;
          }

          .tab-background {
              border-radius: var(--user-tab-rounding) var(--user-tab-rounding) 0px 0px !important;
              margin-block: 1px 0 !important;
          }
                    
          #scrollbutton-up, #scrollbutton-down {
              border-top-width: 1px !important;
              border-bottom-width: 0 !important;
          }

          .tab-background:is([selected], [multiselected]):-moz-lwtheme {
              --lwt-tabs-border-color: rgba(0, 0, 0, 0.5) !important;
              border-bottom-color: transparent !important;
          }
                    
          [brighttext='true'] .tab-background:is([selected], [multiselected]):-moz-lwtheme {
              --lwt-tabs-border-color: rgba(255, 255, 255, 0.5) !important;
              border-bottom-color: transparent !important;
          }

          /* Container color bar visibility */
          .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {
              margin: 0px max(calc(var(--user-tab-rounding) - 3px), 0px) !important;
          }

          #TabsToolbar, #tabbrowser-tabs {
              --tab-min-height: 29px !important;
          }
                    
          #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar, 
          #main-window[sizemode='true'] #toolbar-menubar[autohide='true'] + #TabsToolbar #tabbrowser-tabs {
              --tab-min-height: 30px !important;
          }
                    
          #scrollbutton-up,
          #scrollbutton-down {
              border-top-width: 0 !important;
              border-bottom-width: 0 !important;
          }

          #TabsToolbar, #TabsToolbar > hbox, #TabsToolbar-customization-target, #tabbrowser-arrowscrollbox  {
              max-height: calc(var(--tab-min-height) + 1px) !important;
          }
                    
          #TabsToolbar-customization-target toolbarbutton > .toolbarbutton-icon, 
          #TabsToolbar-customization-target .toolbarbutton-text, 
          #TabsToolbar-customization-target .toolbarbutton-badge-stack,
          #scrollbutton-up,#scrollbutton-down {
              padding-top: 7px !important;
              padding-bottom: 6px !important;
          }
        ";
      };
    };
  };
}
