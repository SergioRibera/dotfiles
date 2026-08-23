{ inputs, ... }:
{
  perSystem = { pkgs, lib, system, ... }:
    let
      pureContainers = lib.genAttrs [ "simple-commits" "wakatime-ls" "discord-presence" ] (
        name:
        pkgs.dockerTools.buildLayeredImage {
          inherit name;
          tag = "latest";
          contents = [ pkgs.${name} ];
          config.Entrypoint = [ "/bin/${name}" ];
        }
      );

      toolContainers = builtins.listToAttrs (
        builtins.filter (x: x != null) (
          map (
            name:
            let
              path = ../tools/${name}/container.nix;
            in
            if builtins.pathExists path then
              let result = builtins.tryEval (import path { inherit inputs pkgs system; });
              in
              if result.success then
                { name = "${name}-container"; value = result.value; }
              else
                null
            else
              null
          ) (builtins.attrNames (builtins.readDir ../tools))
        )
      );
    in
    {
      packages =
        (lib.mapAttrs' (name: value: { name = "${name}-container"; inherit value; }) pureContainers)
        // toolContainers;
    };
}
