{
  crane,
  cranix,
  fenix,
}: final: prev: let
  app = prev.callPackage ./. {inherit crane cranix fenix;};
in {
  app = app.packages.default;
}
