{ pkgs, ... }:
let
  update-pkgs-deps = pkgs.buildEnv {
    name = "update-pkgs-deps";
    paths = with pkgs; [
      fd
      git
      nushell
    ];
  };

  script = pkgs.writeScriptBin "update-pkgs" ''
    #!${pkgs.nushell}/bin/nu

    $env.PATH = ($env.PATH | split row (char esep) | append "${update-pkgs-deps}/bin")

    ${builtins.readFile ./update.nu}
  '';
in {
  type = "app";
  program = "${script}/bin/update-pkgs";
}
