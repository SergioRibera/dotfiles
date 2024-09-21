{ config, pkgs, ... }:
let
  inherit (config) gui user;
in
{
  home-manager.users."${user.username}" = {
    programs.firefox = {
      enable = (gui.enable && user.enableHM && user.browser == "firefox");
      package = pkgs.firefox-devedition-bin;
      profiles.default = {
        isDefault = true;
        name = user.username;
        userChrome = builtins.readFile ./userChrome.css;
        extensions = with pkgs.firefoxAddons; [
          vimium-ff
          hyper-read
          ublock-origin
          refined-github-
          rust-search-extension
          bitwarden-password-manager
        ];
        search = {
          force = true;
          default = "DuckDuckGo";
          privateDefault = "DuckDuckGo";
          order = [ "DuckDuckGo" "Google" ];
          engines = {
            "MyNixOs" = {
              urls = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nx" ];
            };
            "Bing".metaData.hidden = true;
            "Google".metaData.alias = "g"; # builtin engines only support specifying one additional alias
          };
        };
        settings = {
          # Disable auto update
          "app.update.auto" = false;
          "app.update.enabled" = false;
          "app.update.silent" = false;
          "app.update.lastUpdateTime.background-update-timer" = 0;
          "app.update.lastUpdateTime.browser-cleanup-thumbnails" = 0;
          "app.update.lastUpdateTime.search-engine-update-timer" = 0;

          # Privacity and Security
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "browser.contentblocking.category" = "strict";
          "network.cookie.cookieBehavior" = 1; # Disable other cookies
          "browser.safebrowsing.malware.enabled" = true;
          "browser.safebrowsing.phishing.enabled" = true;

          # Performance
          "gfx.webrender.all" = true;
          "layers.acceleration.force-enabled" = true;
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;

          # User Experience
          "browser.tabs.loadInBackground" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.bookmark" = true;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.topsites" = false;
          "browser.search.suggest.enabled" = false;
          "browser.startup.page" = 3; # Restore last session
          "browser.newtabpage.enabled" = false;

          # Customization
          # "browser.uidensity" = 1; # Compact UI
          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          # "browser.startup.homepage" = "https://self.host/homepage";
          # Enable sidebar
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;

          # Disable telemetry
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.enabled" = false;
        };
      };
    };
  };
}
