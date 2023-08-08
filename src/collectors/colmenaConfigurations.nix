{
  inputs,
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "colmenaConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) requireInput walkPaisano checks transformers;

  walk = self:
    walkPaisano self cellBlock (system: cell: [
      (l.mapAttrs (target: config: {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = [config];
        _module.args.name = renamer cell target;
      }))
      (l.mapAttrs (_: checks.bee))
      (l.mapAttrs (_: transformers.colmenaConfigurations))
      (l.filterAttrs (_: config: config.bee.system == system))
    ])
    renamer;

  colmenaTopLevelCliSchema = comb:
    l.fix (this: {
      __schema = "v0";

      nodes = l.mapAttrs (_: c: c.bee._evaled) comb;
      toplevel = l.mapAttrs (_: v: v.config.system.build.toplevel) this.nodes;
      deploymentConfig = l.mapAttrs (_: v: v.config.deployment) this.nodes;
      deploymentConfigSelected = names: l.filterAttrs (name: _: l.elem name names) this.deploymentConfig;
      evalSelected = names: l.filterAttrs (name: _: l.elem name names) this.toplevel;
      evalSelectedDrvPaths = names: l.mapAttrs (_: v: v.drvPath) (this.evalSelected names);
      metaConfig = {
        name = "divnix/hive";
        inherit (import (inputs.self + /flake.nix)) description;
        machinesFile = null;
        allowApplyAll = false;
      };
      introspect = f:
        f {
          lib = nixpkgs.lib // builtins;
          pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
          nodes = l.mapAttrs (_: c: c.bee._unchecked) comb;
        };
    });
in
  requireInput
  "colmena"
  "github:zhaofengli/colmena"
  "`hive.collect \"colmenaConfigurations\"`"
  (self: colmenaTopLevelCliSchema (walk self))
