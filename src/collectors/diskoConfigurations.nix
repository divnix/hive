{
  inputs, # unused for now
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "diskoConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) requireInput walkPaisano;

  sing = self:
    walkPaisano self cellBlock (system: cell: [
      (l.filterAttrs (_: _: "x86_64-linux" == system)) # pick one
    ])
    renamer;
in
  sing
