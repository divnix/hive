{
  inputs, # unused for now
  nixpkgs,
  cellBlock,
}: let
  l = nixpkgs.lib // builtins;

  inherit (import ./walk.nix {inherit nixpkgs cellBlock;}) walkPaisano;

  renamer = cell: target: "${cell}-${target}";
  # same as pasteurize, but for disko where the system doesn't matter
  sing = self:
    walkPaisano self (system: cell: [
      (l.filterAttrs (_: _: "x86_64-linux" == system)) # pick one
    ])
    renamer;
in
  sing
