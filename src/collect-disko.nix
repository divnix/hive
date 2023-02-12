{
  inputs, # unused for now
  nixpkgs,
  cellBlock,
}: let
  l = nixpkgs.lib // builtins;
  inherit (import ./pasteurize.nix {inherit nixpkgs cellBlock;}) sing;
in
  sing
