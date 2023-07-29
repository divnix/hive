{
  inputs,
  nixpkgs,
  root,
  super,
}: cellBlock: renamer: let
  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano checks collectorOps;

  walk = flakeRoot: walkPaisano.root flakeRoot cellBlock (collectorOps.modules cellBlock renamer) renamer;
in
  walk
