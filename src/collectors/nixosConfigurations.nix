{
  inputs, # unused for now
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "nixosConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano checks transformers;

  walk = self: let
    locatedNixosModules =
      if l.hasAttr "nixosModules" self
      then l.attrValues self.nixosModules
      else [];
    locatedNixosProfiles =
      if l.hasAttr "nixosProfiles" self
      then l.attrValues self.nixosProfiles
      else [];
  in
    walkPaisano self cellBlock (system: cell: [
      (l.mapAttrs (target: config: {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = [config];
      }))
      (l.mapAttrs (_: checks.bee locatedNixosModules locatedNixosProfiles))
      (l.mapAttrs (_: transformers.nixosConfigurations))
      (l.filterAttrs (_: config: config.bee.system == system))
      (l.mapAttrs (_: config: config.bee._evaled))
    ])
    renamer;
in
  walk
