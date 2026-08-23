{ ... }:
{
  perSystem = { pkgs, lib, ... }: {
    packages =
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
      in
      lib.mapAttrs' (name: value: {
        name = "${name}-container";
        inherit value;
      }) pureContainers;
  };
}
