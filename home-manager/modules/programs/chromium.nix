{
  lib,
  pkgs,
  config,
  userConfig,
  ...
}:

let
  inherit (lib) optionals concatLists concatStringsSep;

  iconBasePath = "${config.home.homeDirectory}/.local/share/icons/dashboard";

  webApps = [
    {
      name = "Telegram";
      url = "https://web.telegram.org/";
      icon = "${iconBasePath}/telegram.png";
    }
    {
      name = "Discord";
      url = "https://discord.com/app";
      icon = "${iconBasePath}/discord.png";
    }
    {
      name = "Slack";
      url = "https://slack.com/signin";
      icon = "${iconBasePath}/slack.png";
    }
    {
      name = "Zoom";
      url = "https://zoom.us/signin";
      icon = "${iconBasePath}/zoom.png";
    }
  ];

  enableFeaturesList = [
    "PartitionVisitedLinkDatabase"
    "PrefetchPrivacyChanges"
    "SplitCacheByNetworkIsolationKey"
    "SplitCodeCacheByNetworkIsolationKey"
    "EnableCrossSiteFlagNetworkIsolationKey"
    "HttpCacheKeyingExperimentControlGroup"
    "PartitionConnectionsByNetworkIsolationKey"
    "StrictOriginIsolation"
    "ReduceAcceptLanguage"
    "ContentSettingsPartitioning"
    "WebContentsForceDark"
  ];

  disableFeaturesList = [
    "AutofillPaymentCardBenefits"
    "AutofillPaymentCvcStorage"
    "TpcdHeuristicsGrants"
    "TpcdMetadataGrants"
    "EnableHyperlinkAuditing"
    "NTPPopularSitesBakedInContent"
    "UsePopularSitesSuggestions"
    "EnableSnippets"
    "ArticlesListVisible"
    "EnableSnippetsByDse"
    "InterestFeedV2"
    "MediaDrmPreprovisioning"
    "AutofillServerCommunication"
    "PrivacySandboxSettings4"
    "BrowsingTopics"
    "BrowsingTopicsDocumentAPI"
    "BrowsingTopicsParameters"
    "AdaptiveButtonInTopToolbarTranslate"
    "DetailedLanguageSettings"
    "OptimizationHintsFetching"
    "DisableThirdPartyStoragePartitioningDeprecationTrial2"
    "PreloadMediaEngagementData"
    "MediaEngagementBypassAutoplayPolicies"
  ];

  # Convert feature lists to strings
  enableFeaturesArg = "--enable-features=${concatStringsSep "," enableFeaturesList}";
  disableFeaturesArg = "--disable-features=${concatStringsSep "," disableFeaturesList}";

  commandLineArgs = [
    # Aesthetics
    "--force-dark-mode"
    "--gtk-version=4"

    # Performance
    "--enable-gpu-rasterization"
    "--enable-oop-rasterization"
    "--enable-zero-copy"
    "--ignore-gpu-blocklist"

    # Wayland
    "--ozone-platform=wayland"
    "--enable-features=UseOzonePlatform"

    # Misc
    "--disk-cache=$XDG_RUNTIME_DIR/chromium-cache"
    "--disable-features=reading-from-canvas"
    "--no-first-run"
    "--disable-wake-on-wifi"
    "--disable-breakpad"
    "--no-default-browser-check"
    "--disable-features=speech-api,speech-synthesis-api"

    # Security
    "--extension-content-verification=enforce_strict"
    "--extensions-install-verification=enforce_strict"
    "--no-pings"
    "--component-updater=require_encryption"
    "--no-crash-upload"
    enableFeaturesArg
    disableFeaturesArg
  ];

  # Custom wrapper for Google Chrome with all flags
  chromeWrapper = pkgs.writeShellScriptBin "google-chrome-custom" ''
    exec ${pkgs.google-chrome}/bin/google-chrome-stable ${concatStringsSep " " commandLineArgs} "$@"
  '';
in
{
  home.packages = optionals userConfig.machineConfig.workstation.enable (
    [
      pkgs.google-chrome
      chromeWrapper
    ]
    ++ (map (
      app:
      pkgs.makeDesktopItem {
        inherit (app) name;
        exec = "${chromeWrapper}/bin/google-chrome-custom --app=${app.url}";
        inherit (app) icon;
        comment = "Web App for ${app.name}";
        desktopName = app.name;
        categories = [ "Network" ];
      }
    ) webApps)
  );
}
