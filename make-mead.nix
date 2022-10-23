{
  nixpkgs,
  cellBlock ? "nixosConfigurations",
}: let
  l = nixpkgs.lib // builtins;
  inherit (import ./pasteurize.nix {inherit nixpkgs cellBlock;}) pasteurize stir;
in
  self: let
    comb = pasteurize self;
    evalNode = extra: name: config: let
      inherit (stir config) evalConfig system;
    in
      evalConfig {
        inherit system;
        modules = [extra config];
      };
  in
    l.mapAttrs (evalNode {}) comb
