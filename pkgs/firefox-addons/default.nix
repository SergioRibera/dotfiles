{ lib, stdenv, fetchurl }:
let
  buildFirefoxXpiAddon = { pname, version, addonId, url, sha256, meta, ... }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";
      inherit version;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        cp -v "$src" "$dst/${addonId}.xpi"
      '';

      meta = meta // {
        platforms = lib.platforms.all;
      };
    };

  getJson = builtins.fromJSON (builtins.readFile ./default.lock);

  jsonAsAttrs = builtins.listToAttrs (map (addon: { name = addon.slug; value = addon; }) getJson);

  addons = lib.makeExtensible (self:
    lib.mapAttrs (name: addon:
      buildFirefoxXpiAddon {
        pname = name;
        inherit (addon) version addonId url;
        sha256 = builtins.substring 7 64 addon.sha256;
        meta = {
          homepage = addon.homepage or null;
          description = addon.description or null;
          license = if addon ? license then lib.getLicenseFromSpdxId addon.license else null;
        };
      }
    ) jsonAsAttrs
  );
in
  addons
