{
  inputs,
  nixpkgs,
  root,
  super,
}: cellBlock: renamer: let
  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano checks;
  inherit (super) ops;

  walk = flakeRoot: walkPaisano.root flakeRoot cellBlock (ops.modules renamer) renamer;
in
  walk
