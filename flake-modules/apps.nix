{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    apps = import ../apps { inherit system inputs pkgs; };
  };
}
