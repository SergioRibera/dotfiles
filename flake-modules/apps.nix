{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      toolApps = builtins.listToAttrs (
        builtins.filter (x: x != null) (
          map (
            tool:
            let
              path = ../tools/${tool}/app.nix;
            in
            if builtins.pathExists path then
              let
                result = builtins.tryEval (import path { inherit inputs pkgs system; });
                app = result.value;
              in
              if result.success then
                {
                  name = tool;
                  value = {
                    inherit (app) type program;
                  };
                }
              else
                null
            else
              null
          ) (builtins.attrNames (builtins.readDir ../tools))
        )
      );
    in
    {
      apps = toolApps // (import ../apps { inherit system inputs pkgs; });
    };
}
