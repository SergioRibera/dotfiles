def get-latest-commit [owner: string, repo: string] {
    let github_api = $"https://api.github.com/repos/($owner)/($repo)/commits/HEAD"
    let response = (http get $github_api)
    $response.sha
}

def get-latest-release [owner: string, repo: string] {
    let github_api = $"https://api.github.com/repos/($owner)/($repo)/releases/latest"
    let response = (http get -e $github_api)
    if (($response | get -i status | is-not-empty) and ($response.status == 404)) or ($response | get -i tag_name | is-empty) {
        return null
    }
    $response.tag_name
}

def download-cargo-lock [owner: string, repo: string, rev: string] {
    let raw_url = $"https://raw.githubusercontent.com/($owner)/($repo)/($rev)/Cargo.lock"
    let response = (http get -e $raw_url)
    if ($response == "404: Not Found") {
        return ""
    }
    $response
}

def calculate-hash [owner: string, repo: string, rev: string] {
    let hash = (nix-prefetch-url --type sha256 --unpack $"https://github.com/($owner)/($repo)/archive/($rev).tar.gz")
    $hash
}

def update-nix-file [file: string] {
    let content = (open $file)
    let lines = ($content | lines)
    let owners = ($lines | parse -r 'owner = "(?P<owner>.*?)";')
    let repos = ($lines | parse -r 'repo = "(?P<repo>.*?)";')

    if ($owners | is-empty) and ($repos | is-empty) {
        print $"The process not apply for ($file)"
        return
    }

    # Extraer información del archivo
    let owner = ($owners
        | get owner
        | first)

    let repo = ($repos
        | get repo
        | first)

    # Determinar si usa version o commit
    let uses_version = ($content | str contains "version =")

    mut is_tag = false
    # Obtener nueva versión o commit
    let new_rev = if $uses_version {
        let latest_release = (get-latest-release $owner $repo)
        if $latest_release == null {
            (get-latest-commit $owner $repo)
        } else {
            $is_tag = true
            $latest_release
        }
    } else {
        (get-latest-commit $owner $repo)
    }

    # Calcular nuevo hash
    let new_hash = (calculate-hash $owner $repo $new_rev)

    # Actualizar el archivo
    mut updated_content = ($content
        | str replace --regex 'version = "[^"]+";' $"version = \"($new_rev)\";"
        | str replace --regex 'rev = "[^"]+";' $"rev = \"($new_rev)\";"
        | str replace --regex 'sha256 = "sha256-[^"]+"' $"sha256 = \"sha256-($new_hash)\"")

    # Manejar Cargo.lock si existe
    if ($content | str contains "cargoLock = {") {
        let new_rev = if $is_tag {
            $"refs/tags/($new_rev)"
        } else {
            $new_rev
        }
        let cargo_lock = (download-cargo-lock $owner $repo $new_rev)
        if ($cargo_lock | is-not-empty) {
            let cargo_lock_path = ($file | path dirname | path join "Cargo.lock")
            $cargo_lock | save -f $cargo_lock_path
            let cargo_hash = (nix-hash --flat --sri --type sha256 $cargo_lock_path)
            $updated_content = ($updated_content | str replace --regex 'cargoHash = "[^"]+";' $"cargoHash = \"($cargo_hash)\";")
        }
    }

    # Guardar cambios
    $updated_content | save -f $file

    echo $"Updated ($file) to version/commit ($new_rev)"
}

# Función principal
def main [] {
    let nix_files = (fd -e nix -E "scenefx/default.nix" ".*" pkgs | lines)
    for file in $nix_files {
        print $"Try process ($file)"
        update-nix-file $file
    }
}
