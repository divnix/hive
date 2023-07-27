{
  inputs, # unused for now
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "darwinConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) requireInput walkPaisano bee-module;
  inherit (bee-module) beeModule checkBeeAnd tranformToDarwinConfig;

  walk = self:
    walkPaisano self cellBlock (system: cell: [
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
