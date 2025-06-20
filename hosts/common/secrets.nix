{ config, ... }:
let
  inherit (config.user) username;
  makeSecret = name: {
    "${name}" = {
      file = ../../secrets/${name}.age;
      owner = username;
      group = "wheel";
    };
  };
in {
  age.secrets = (makeSecret "github")
    // (makeSecret "cftun01")
    // (makeSecret "rustlanges")
    // (makeSecret "hosts");
}
