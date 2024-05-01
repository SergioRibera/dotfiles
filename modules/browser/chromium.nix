{...}: {
  enable = true;
  extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    "icallnadddjmdinamnolclfjanhfoafe" # fastforward
    "cfahdpkjihoomfomffdbmamapgdpohoe" # seven json viewer
    "ihcjicgdanjaechkgeegckofjjedodee" # malwarebytes
    "hlepfoohegkhhmjieoechaddaejaokhf" # refined github
    "pljfkbaipkidhmaljaaakibigbcmmpnc" # atom matreial icons (github, gitlab, azure, etc)
    "jlmafbaeoofdegohdhinkhilhclaklkp" # octolinker
    "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  ];
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
    "ShowHomeButton" = false;
    "GoogleSearchSidePanelEnabled" = false;
    "SearchSuggestEnabled" = false;
    "HomepageLocation" = ""; # TODO: configure home page of chromium
    "DefaultSearchProviderAlternateURLs" = [
      "https://crates.io/search?q={searchTerms}"
      "https://mynixos.com/search?q={searchTerms}"
      "https://github.com/search?q={searchTerms}+language%3ARust&type=repositories"
    ];
    "VoiceInteractionContextEnabled" = false;
  };
}
