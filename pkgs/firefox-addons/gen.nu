#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

def fetch-addon [slug: string] {
  let url = $'https://addons.mozilla.org/api/v5/addons/addon/($slug)/?app=firefox&lang=en-US'
  print $'Try get: ($slug)'
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
  let addons = if ($slugs | length) == 0 {
    [
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
    ]
  } else {
    $slugs
  }
  # change this when the following gets resolved
  # https://github.com/nushell/nushell/issues/12195
  let file = $"(pwd)/default.lock"
  let addons = $addons | each { |slug| fetch-addon $slug }
  $addons | to json | save --force $file
}
