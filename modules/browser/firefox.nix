{ config, lib, stdenv }@args:
let
  buildFirefoxXpiAddon = lib.makeOverridable ({ stdenv ? args.stdenv
                                              , fetchurl ? args.fetchurl
                                              , pname
                                              , version
                                              , addonId
                                              , sha256
                                              , meta
                                              , ...
                                              }:
    stdenv.mkDerivation rec {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {
        url = "https://addons.mozilla.org/firefox/downloads/file/${name}.xpi";
        inherit sha256;
      };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = { inherit addonId; };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });
in
{
  enable = true;
  preferencesStatus = "user";

  # Search firefox extension
  # https://nur.nix-community.org/repos/rycee/
  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons
  extensions = [
    (buildFirefoxXpiAddon {
      pname = "4263752/bitwarden_password_manager";
      version = "2024.4.1";
      addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
      sha256 = "1ba1e66cb9a4ee3bf80a81fc31348b04162385455d2b02f9902473e3931d9693";
      meta = with lib;
        {
          homepage = "https://bitwarden.com";
          description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
          license = licenses.gpl3;
          mozPermissions = [
            "<all_urls>"
            "*://*/*"
            "tabs"
            "contextMenus"
            "storage"
            "unlimitedStorage"
            "clipboardRead"
            "clipboardWrite"
            "idle"
            "webRequest"
            "webRequestBlocking"
            "file:///*"
            "https://*/*"
            "https://lastpass.com/export.php"
          ];
          platforms = platforms.all;
        };
    })
    (buildFirefoxXpiAddon {
      pname = "4258067/fastforwardteam";
      version = "0.2383";
      addonId = "addon@fastforward.team";
      sha256 = "eec6328df3df1afe2cb6a331f6907669d804235551ea766d48655f8f831caf28";
      meta = with lib;
        {
          homepage = "https://fastforward.team";
          description = "Don't waste time with compliance. Use FastForward to skip annoying URL \"shorteners\".";
          license = licenses.unlicense;
          mozPermissions = [
            "alarms"
            "storage"
            "webNavigation"
            "tabs"
            "declarativeNetRequestWithHostAccess"
            "<all_urls>"
          ];
          platforms = platforms.all;
        };
    })
    (buildFirefoxXpiAddon {
      pname = "ublock-origin";
      version = "1.57.2";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4261710/ublock_origin-1.57.2.xpi";
      sha256 = "9928e79a52cecf7cfa231fdb0699c7d7a427660d94eb10d711ed5a2f10d2eb89";
      meta = with lib;
        {
          homepage = "https://github.com/gorhill/uBlock#ublock-origin";
          description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
          license = licenses.gpl3;
          mozPermissions = [
            "alarms"
            "dns"
            "menus"
            "privacy"
            "storage"
            "tabs"
            "unlimitedStorage"
            "webNavigation"
            "webRequest"
            "webRequestBlocking"
            "<all_urls>"
            "http://*/*"
            "https://*/*"
            "file://*/*"
            "https://easylist.to/*"
            "https://*.fanboy.co.nz/*"
            "https://filterlists.com/*"
            "https://forums.lanik.us/*"
            "https://github.com/*"
            "https://*.github.io/*"
            "https://*.letsblock.it/*"
            "https://github.com/uBlockOrigin/*"
            "https://ublockorigin.github.io/*"
            "https://*.reddit.com/r/uBlockOrigin/*"
          ];
          platforms = platforms.all;
        };
    })
  ];
}
