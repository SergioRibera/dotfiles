#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

def fetch-addon [slug: string] {
  let url = $'https://addons.mozilla.org/api/v5/addons/addon/($slug)/?app=firefox&lang=en-US'
  let response = http get $url

  let addon = {
    slug: $slug
    name: $response.name.en-US,
    version: $response.current_version.version,
    addonId: $response.guid,
    url: $response.current_version.file.url
    sha256: $response.current_version.file.hash
    homepage: ($response | get -i homepage.url.en-US | default $response.url)
    description: $response.summary.en-US
    license: $response.current_version.license.slug
  }
  return $addon
}

export def main [...slugs: string] {
  # change this when the following gets resolved
  # https://github.com/nushell/nushell/issues/12195
  let file = $"(pwd)/default.lock"
  let addons = $slugs | each { |slug| fetch-addon $slug }
  $addons | to json | save --force $file
}
