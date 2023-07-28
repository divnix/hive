{
  inputs, # unused for now
  nixpkgs,
  root,
}: cellBlock: renamer: let
  l = nixpkgs.lib // builtins;

  inherit (root) requireInput walkPaisano;

  # same as pasteurize, but for disko where the system doesn't matter
  sing = self:
    walkPaisano.root self cellBlock (system: cell: [
      (l.filterAttrs (_: _: "x86_64-linux" == system)) # pick one
    ])
    renamer;
in
  sing
