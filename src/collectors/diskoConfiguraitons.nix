{
  inputs, # unused for now
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "diskoConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) requireInput walkPaisano;

  # same as pasteurize, but for disko where the system doesn't matter
  sing = self:
    walkPaisano self cellBlock (system: cell: [
      (l.filterAttrs (_: _: "x86_64-linux" == system)) # pick one
    ])
    renamer;
in
  sing
