{
  inputs, # unused for now
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "nixosConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano checks transformers;

  walk = self:
    walkPaisano self cellBlock (system: cell: [
      (l.mapAttrs (target: config: {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = [config];
      }))
      (l.mapAttrs (_: checks.bee))
      (l.mapAttrs (_: transformers.nixosConfigurations))
      (l.filterAttrs (_: config: config.bee.system == system))
      (l.mapAttrs (_: config: config.bee._evaled))
    ])
    renamer;
in
  walk
