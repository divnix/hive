{
  inputs, # unused for now
  nixpkgs,
  cellBlock,
}: renamer: let
  l = nixpkgs.lib // builtins;
  inherit (import ./walk.nix {inherit nixpkgs cellBlock;}) walkPaisano;
  inherit (import ./bee-module.nix {inherit nixpkgs;}) beeModule checkBeeAnd tranformToDarwinConfig;

  walk = self:
    walkPaisano self (system: cell: [
      (l.mapAttrs (target: config: {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = [config];
      }))
      (l.mapAttrs (_: checkBeeAnd tranformToDarwinConfig))
      (l.filterAttrs (_: config: config.bee.system == system))
      (l.mapAttrs (_: config: config.bee._evaled))
    ])
    renamer;
in
  walk
