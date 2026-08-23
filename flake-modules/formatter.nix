{ ... }:
{
  perSystem = { pkgs, ... }: {
    formatter = pkgs.treefmt.withConfig {
      runtimeInputs = [ pkgs.nixfmt-rfc-style ];
      settings = {
        on-unmatched = "info";
        formatter.nixfmt = {
          command = "nixfmt";
          includes = [ "*.nix" ];
        };
      };
    };
  };
}
