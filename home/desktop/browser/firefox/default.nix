{ config, pkgs, ... }:
let
  inherit (config) gui user;
in
{
  home-manager.users.${user.username} = {
    home.sessionVariables = {
      MOZ_LEGACY_PROFILES = 1;
      MOZ_ALLOW_DOWNGRADE = 1;
    };
    programs.firefox = {
      enable = (gui.enable && user.enableHM && user.browser == "firefox");
      package = pkgs.firefox-devedition.overrideAttrs (prev: {
        pipewireSupport = true;
        desktopItem = pkgs.makeDesktopItem rec {
          name = "firefox-devedition";
          icon = name;
          exec = "${name} --name firefox -P ${user.username} %U";
          desktopName = "Firefox Developer Edition";
          startupWMClass = name;
          startupNotify = true;
          terminal = false;
          genericName = "Web Browser";
          categories = [ "Network" "WebBrowser" ];
          mimeTypes = [
            "text/html"
            "text/xml"
            "application/xhtml+xml"
            "application/pdf"
            "application/vnd.mozilla.xul+xml"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];
          actions = {
            new-window = {
              name = "New Window";
              exec = "${name} -P ${user.username} --new-window %U";
            };
            new-private-window = {
              name = "New Private Window";
              exec = "${name} -P ${user.username} --private-window %U";
            };
            profile-manager-window = {
              name = "Profile Manager";
              exec = "${name} -P ${user.username} --ProfileManager";
            };
          };
        };
      });
      policies = {
        BackgroundAppUpdate = false;
        DisableAppUpdate = true;
      };
      profiles.dev-edition-default = {
        id = 0;
        isDefault = true;
        name = user.username;
        userChrome = builtins.readFile ./userChrome.css;
        extensions.packages = with pkgs.firefoxAddons; [
          vimium-ff
          hyper-read
          malwarebytes
          ublock-origin
          refined-github-
          fastforwardteam
          auto-tab-discard
          rust-search-extension
          adaptive-tab-bar-colour
          bitwarden-password-manager
        ];
        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
          order = [ "ddg" "google" ];
          engines = {
            "MyNixOs" = {
              urls = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nx" ];
            };
            "bing".metaData.hidden = true;
            "google".metaData.alias = "g"; # builtin engines only support specifying one additional alias
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
          "network.cookie.cookieBehavior" = 4; # Disable cookies banner
          "browser.safebrowsing.malware.enabled" = true;
          "browser.safebrowsing.phishing.enabled" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          # Performance
          "gfx.webrender.all" = true;
          "layers.acceleration.force-enabled" = true;
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;

          # User Experience
          "browser.tabs.loadInBackground" = true;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.bookmark" = true;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.topsites" = false;
          "browser.search.suggest.enabled" = false;
          "browser.startup.page" = 3; # Restore last session
          "browser.newtabpage.enabled" = false;
          "media.eme.enabled" = true; # Enable DRM
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          "media.hardwaremediakeys.enabled" = true;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.sections" = false;
          "extensions.webextensions.restrictedDomains" = "";
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;

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
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              nav-bar = [
                "urlbar-container"
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
                "_2160556a-1fc4-453c-9dba-6707507bf5aa_-browser-action"
                "unified-extensions-button"
              ];
              unified-extensions-area = [
                "ublock0_raymondhill_net-browser-action"
                "_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action"
                "_04188724-64d3-497b-a4fd-7caffe6eab29_-browser-action"
                "atbc_easonwong-browser-action"
                "addon_fastforward_team-browser-action"
                "_242af0bb-db11-4734-b7a0-61cb8a9b20fb_-browser-action"
                "_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action"
              ];
              vertical-tabs = ["tabbrowser-tabs"];
              TabsToolbar = [];
              toolbar-menubar = [];
              PersonalToolbar = [];
              widget-overflow-fixed-list = [];
            };
            seen = [
              "developer-button"
              "_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              "_2160556a-1fc4-453c-9dba-6707507bf5aa_-browser-action"
              "_04188724-64d3-497b-a4fd-7caffe6eab29_-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
              "atbc_easonwong-browser-action"
              "save-to-pocket-button"
              "profiler-button"
              "addon_fastforward_team-browser-action"
              "_242af0bb-db11-4734-b7a0-61cb8a9b20fb_-browser-action"
              "_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action"
            ];
            dirtyAreaCache = [ "nav-bar" "PersonalToolbar" "unified-extensions-area" "toolbar-menubar" "TabsToolbar"];
            currentVersion = 22;
            newElementCount = 9;
          };

          # Extensions
          "extensions.allowPrivateBrowsingByDefault" = true;
          # Configuraciones específicas para extensiones
          "extensions.webextensions.ExtensionStorageIDB.migrated.addon@darkreader.org" = true;
          "extensions.webextensions.ExtensionStorageIDB.migrated.{446900e4-71c2-419f-a6a7-df9c091e268b}" = true;
          "extensions.webextensions.ExtensionStorageIDB.migrated.bitwarden@bitwarden.com" = true;
          "extensions.webextensions.ExtensionStorageIDB.migrated.hyper-read@example.com" = true;
          "extensions.webextensions.ExtensionStorageIDB.migrated.{1dcc6ffb-4395-4c0d-aef7-e89bcdeb4a15}" = true;
          "extensions.webextensions.ExtensionStorageIDB.migrated.{bee66b20-2874-45e8-9446-ba20faa31a65}" = true;
          "extensions.webextensions.ExtensionStorageIDB.migrated.uBlock0@raymondhill.net" = true;
          "extensions.webextensions.ExtensionStorageIDB.migrated.vimium-c@gdh1995.cn" = true;


          # Disable telemetry
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "toolkit.telemetry.enabled" = false;

          # SmoothFox
          # /****************************************************************************************
          #  * OPTION: NATURAL SMOOTH SCROLLING V3 [MODIFIED]                                      *
          # ****************************************************************************************/
          # credit: https://github.com/AveYo/fox/blob/cf56d1194f4e5958169f9cf335cd175daa48d349/Natural%20Smooth%20Scrolling%20for%20user.js
          # recommended for 120hz+ displays
          # largely matches Chrome flags: Windows Scrolling Personality and Smooth Scrolling
          "apz.overscroll.enabled" = true; # DEFAULT NON-LINUX
          "general.smoothScroll" = true; # DEFAULT
          "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
          "general.smoothScroll.msdPhysics.enabled" = true;
          "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
          "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
          "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
          "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
          "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
          "general.smoothScroll.currentVelocityWeighting" = "1";
          "general.smoothScroll.stopDecelerationWeighting" = "1";
          "mousewheel.default.delta_multiplier_y" = 300; # 250-400; adjust this number to your liking
        };
      };
    };
  };
}
