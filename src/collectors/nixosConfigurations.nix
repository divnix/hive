{
  inputs, # unused for now
  nixpkgs,
  root,
  super,
}: let
  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano checks transformers;
  inherit (super) ops;
in {
  modulesCellBlock = "nixosModules";
  profilesCellBlock = "nixosProfiles";
  transformer = transformers.nixosConfigurations;

  __functor = self: cellBlock: renamer: flakeRoot:
    walkPaisano.root flakeRoot cellBlock (system: cell: let
      locatedNixosModules =
        l.attrValues (walkPaisano.cell flakeRoot cell self.modulesCellBlock (ops.modules renamer) renamer);
      locatedNixosProfiles =
        l.attrValues (walkPaisano.cell flakeRoot cell self.profilesCellBlock (ops.profiles renamer) renamer);
    in [
      (l.mapAttrs (target: config: {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = [config];
      }))
      (l.mapAttrs (_: checks.bee [] []))
      (l.mapAttrs (_: checkResults: let
        extraModules = checkResults.evaled.config.bee.extraModules;
        extraProfiles = checkResults.evaled.config.bee.extraProfiles;
      in
        checks.bee
        (locatedNixosModules ++ extraModules)
        (locatedNixosProfiles ++ extraProfiles)
        checkResults.locatedConfig))
      (l.mapAttrs (_: self.transformer))
      (l.filterAttrs (_: config: config.bee.system == system))
      (l.mapAttrs (_: config: config.bee._evaled))
    ])
    renamer;
}
