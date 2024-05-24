{config, ...}: let
  inherit (config.gui.theme) colors;
in {
  enable = true;
  extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    "icallnadddjmdinamnolclfjanhfoafe" # fastforward
    "cfahdpkjihoomfomffdbmamapgdpohoe" # seven json viewer
    "ihcjicgdanjaechkgeegckofjjedodee" # malwarebytes
    "hlepfoohegkhhmjieoechaddaejaokhf" # refined github
    "pljfkbaipkidhmaljaaakibigbcmmpnc" # atom material icons (github, gitlab, azure, etc)
    "jlmafbaeoofdegohdhinkhilhclaklkp" # octolinker
    "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  ];
  # https://chromeenterprise.google/policies
  extraOpts = {
    "BrowserSignin" = 2;
    "BookmarkBarEnabled" = false;
    "SyncDisabled" = true;
    "PasswordManagerEnabled" = false;
    "PasswordSharingEnabled" = false;
    "SpellcheckEnabled" = true;
    "SpellcheckLanguage" = [
      "es"
      "en-US"
    ];
    "ClearBrowsingDataOnExitList" = [
      "download_history"
      "password_signin"
      "browsing_history"
    ];
    "RestoreOnStartup" = 1;
    "ShowHomeButton" = false;
    "BrowserLabsEnabled" = false;
    "AdsSettingForIntrusiveAdsSites" = 2;
    "GoogleSearchSidePanelEnabled" = false;
    "SearchSuggestEnabled" = false;
    "DefaultSearchProviderEnabled" = true;
    "DefaultSearchProviderAlternateURLs" = [
      "https://google.com/search?q={searchTerms}"
      "https://duckduckgo.com/?q={searchTerms}"
      "https://crates.io/search?q={searchTerms}"
      "https://mynixos.com/search?q={searchTerms}"
      "https://github.com/search?q={searchTerms}+language%3ARust&type=repositories"
    ];
    "VoiceInteractionContextEnabled" = false;
    "MediaRouterCastAllowAllIPs" = true;
    "TabOrganizerSettings" = 1;
    "DevToolsGenAiSettings" = 2; # disable

    "ShowCastIconInToolbar" = true;
    "UserDisplayName" = config.user.username;
    "CreateThemesSettings" = 2;
    "BrowserThemeColor" = colors.base01;

    "ExtensionSettings" = {
      # bitwarden
      "nngceckbapebfimnlniiiahkandclblb" = {
        "toolbar_pin" = "force_pinned";
      };
    };
  };
}
