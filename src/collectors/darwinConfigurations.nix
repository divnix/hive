{
  inputs, # unused for now
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "darwinConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) requireInput walkPaisano checks transformers;

  walk = self: let
    locatedDarwinModules =
      if l.hasAttr "darwinModules" self
      then l.attrValues self.darwinModules
      else [];
    locatedDarwinProfiles =
      if l.hasAttr "darwinProfiles" self
      then l.attrValues self.darwinProfiles
      else [];
  in
    walkPaisano self cellBlock (system: cell: [
      (l.mapAttrs (target: config: {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = [config];
      }))
      (l.mapAttrs (_: checks.bee locatedDarwinModules locatedDarwinProfiles))
      (l.mapAttrs (_: transformers.darwinConfigurations))
      (l.filterAttrs (_: config: config.bee.system == system))
      (l.mapAttrs (_: config: config.bee._evaled))
    ])
    renamer;
in
  walk
