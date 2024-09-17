{ config, lib, pkgs, inputs, ... }:
let
  inherit (config) gui user;
  mkPrefs = attrs:
    let
      toPrefsValue = value:
      if builtins.isBool value then
          if value then "true" else "false"
      else if builtins.isInt value then
          toString value
      else if builtins.isString value then
          ''"${value}"''
      else
          throw "Tipo de valor no soportado: ${builtins.typeOf value}";

      prefsLines = lib.mapAttrsToList (name: value:
      ''user_pref("${name}", ${toPrefsValue value});''
      ) attrs;
    in
      lib.concatStringsSep "\n" prefsLines;
in
{
  # xdg.mimeApps.defaultApplications = lib.mkIf (gui.enable && user.browser == "firefox") {
  #   "x-scheme-handler/http" = "zen-browser.desktop";
  #   "x-scheme-handler/https" = "zen-browser.desktop";
  #   "application/xhtml+xml" = "zen-browser.desktop";
  #   "text/html" = "zen-browser.desktop";
  # };
  home-manager.users."${user.username}" = {
    # programs.firefox = {
    #   enable = true;
    #   package = inputs.zen-browser.packages.${pkgs.system}.specific;
    #   profiles.default = {
    #     isDefault = true;
    #     name = user.username;
    #     userChrome = builtins.readFile ./userChrome.css;
    #     extensions = with pkgs.firefoxAddons; [
    #       vimium-ff
    #       hyper-read
    #       ublock-origin
    #       refined-github-
    #       rust-search-extension
    #       bitwarden-password-manager
    #     ];
    #   };
    # };
    #
    home = lib.mkIf (gui.enable && user.enableHM && user.browser == "firefox") {
      packages = [ inputs.zen-browser.packages.${pkgs.system}.specific ];
      file.".zen/chrome/userChrome.css".source = ./userChrome.css;
      file.".zen/profiles.ini".text = lib.generators.toINI {} {
        General = {
          StartWithLastProfile = 1;
          Version = 2;
        };

        Profile0 = {
          Name = user.username;
          Path = user.username;
          IsRelative = 1;
          ZenAvatarPath = "chrome://browser/content/zen-avatars/avatar-46.svg";
          Default = 1;
        };
      };
      file.".zen/default/extensions" = {
          source = let
          env = pkgs.buildEnv {
              name = "zen-extensions";
              paths = with pkgs.firefoxAddons; [
                vimium-ff
                hyper-read
                ublock-origin
                refined-github-
                rust-search-extension
                bitwarden-password-manager
              ];
          };
          in "${env}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
          recursive = true;
          force = true;
      };
      file.".zen/default/search.json.mozlz4" = {
        force = true;
        source = let
          settings = {
            version = 6;
            force = true;
            default = "DuckDuckGo";
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
        in pkgs.runCommand "search.json.mozlz4" {
          nativeBuildInputs = with pkgs; [ mozlz4a ];
          json = builtins.toJSON settings;
        } ''
          mozlz4a <(echo "$json") "$out"
        '';
      };
      file.".zen/default/prefs.js".text = mkPrefs {
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
        "browser.uidensity" = 1; # Compact UI
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        # "browser.startup.homepage" = "https://self.host/homepage";

        # Desactivar telemetría
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;

        # Zen
        "zen.keyboard.shortcuts" = "{\"zenSplitViewGrid\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"G\"},\"zenSplitViewVertical\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"V\"},\"zenSplitViewHorizontal\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"H\"},\"zenSplitViewClose\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"U\"},\"zenChangeWorkspace\":{\"ctrl\":true,\"alt\":false,\"shift\":true,\"meta\":false,\"key\":\"E\"},\"zenToggleCompactMode\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"C\"},\"zenToggleCompactModeSidebar\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"S\"},\"zenToggleCompactModeToolbar\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"T\"},\"zenToggleWebPanels\":{\"ctrl\":true,\"alt\":false,\"shift\":true,\"meta\":false,\"key\":\"P\"},\"openScreenCapture\":{\"ctrl\":true,\"alt\":false,\"shift\":false,\"meta\":false,\"key\":\"s\"},\"openNewPrivateWindow\":{\"ctrl\":true,\"alt\":false,\"shift\":true,\"meta\":false,\"key\":\"N\"}}";

      };
    };
  };
}
