{
  inputs,
  nixpkgs,
  root,
  self,
}: let
  l = nixpkgs.lib // builtins;

  inherit
    (root)
    checks
    walkPaisano
    ;
in {
  nixosConfigurations = flakeRoot: cellBlock: modulesCellBlock: profilesCellBlock: transformer: renamer: system: cell: let
    locatedCellModules =
      l.attrValues (walkPaisano.cell flakeRoot cell modulesCellBlock (self.modules modulesCellBlock renamer) renamer);
    locatedCellProfiles =
      l.attrValues (walkPaisano.cell flakeRoot cell profilesCellBlock (self.profiles profilesCellBlock renamer) renamer);
  in [
    (l.mapAttrs (target: config: {
      _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
      imports = [config];
    }))
    (l.mapAttrs (_: checks.bee system))
    (l.mapAttrs (_: checkResults: let
      extraModules = checkResults.evaled.config.bee.extraModules;
      extraProfiles = checkResults.evaled.config.bee.extraProfiles;
    in
      checkResults
      // {
        locatedModules = locatedCellModules ++ extraModules;
        locatedProfiles = locatedCellProfiles ++ extraProfiles;
      }))
    (l.mapAttrs (_: transformer))
    (l.filterAttrs (_: config: config.bee.system == system))
    (l.mapAttrs (_: config: config.bee._evaled))
  ];

  modules = cellBlock: renamer: system: cell: [
    (l.mapAttrs (target: module: ({
        pkgs,
        config,
        lib,
        ...
      } @ moduleInputs: let
        evaled = module (renamer cell) (renamer cell target) moduleInputs;
      in {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = l.attrByPath ["imports"] [] evaled;
        options.bee.modules."${renamer cell target}" =
          {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "En-/Disable module ${renamer cell target}";
            };
          }
          // (l.attrByPath ["options"] {} evaled);
        config = lib.mkIf (config.bee.modules."${renamer cell target}".enable) (l.attrByPath ["config"] {} evaled);
      })))
    (l.mapAttrs (target: checks.modules))
  ];

  profiles = cellBlock: renamer: system: cell: [
    (l.mapAttrs (target: profile: ({
        pkgs,
        config,
        lib,
        ...
      } @ moduleInputs: let
        evaled = profile (renamer cell) moduleInputs;
      in {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = l.attrByPath ["imports"] [] evaled;
        options.bee._profiles."${renamer cell target}".enable = lib.mkOption {
          type = lib.types.bool;
          default = lib.elem (renamer cell target) config.bee.profiles;
          description = "En-/Disable profile ${renamer cell target}";
        };
        config =
          lib.mkIf
          (config.bee._profiles."${renamer cell target}".enable) (
            if l.hasAttr "config" evaled
            then evaled.config
            else evaled
          );
      })))
    (l.mapAttrs (target: checks.profiles))
  ];
}
