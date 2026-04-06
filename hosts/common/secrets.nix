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
in
{
  age.secrets =
    (makeSecret "github")
    // (makeSecret "git_sign")
    // (makeSecret "git_sign_pub")
    // (makeSecret "cftun01")
    // (makeSecret "rustlanges")
    // (makeSecret "hosts");
}
