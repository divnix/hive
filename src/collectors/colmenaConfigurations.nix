{
  inputs,
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "colmenaConfigurations";

  l = nixpkgs.lib // builtins;

  inherit (root) requireInput walkPaisano checks transformers;
  inherit (inputs) colmena;

  colmenaModules = l.map (l.setDefaultModuleLocation (./collect-colmena.nix + ":colmenaModules")) [
    # these modules are tied to the below schemaversion
    # so we fix them here
    colmena.nixosModules.assertionModule
    colmena.nixosModules.keyChownModule
    colmena.nixosModules.keyServiceModule
    colmena.nixosModules.deploymentOptions
    {
      environment.etc."nixos/configuration.nix".text = ''
        throw '''
          This machine is not managed by nixos-rebuild, but by colmena.
        '''
      '';
    }
  ];

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
      (l.mapAttrs (target: transformers.colmenaConfigurations (renamer cell target)))
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
