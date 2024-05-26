{ pkgs, ... }: {
  mkTheme = import ./theme { inherit pkgs; };
}
