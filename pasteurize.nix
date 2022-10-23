{
  nixpkgs,
  cellBlock,
}: let
  l = nixpkgs.lib // builtins;
  evalModulesMinimal =
    (import (nixpkgs + /nixos/lib/default.nix) {
      inherit (nixpkgs) lib;
      # don't show the warning.
      featureFlags.minimalModules = {};
    })
    .evalModules;

  combCheckModule = let
    erase = optionName: {options, ...}: let
      opt = l.getAttrFromPath optionName options;
    in {
      options = l.setAttrByPath optionName (l.mkOption {visible = false;});
      config._hive_erased = [
        {
          assertion = !opt.isDefined;
          message = ''
            The option definition `${l.showOption optionName}' in ${l.showFiles opt.files}  is not supported by divnix/hive.

            This is a Standard simplification.

              - Please set 'config.bee.pkgs' to an instantiated version of nixpkgs.
              - Also declare the host system via 'config.bee.system'.
          '';
        }
      ];
    };
  in
    {config, ...}: {
      imports = [
        (erase ["nixpkgs" "config"])
        (erase ["nixpkgs" "overlays"])
        (erase ["nixpkgs" "system"])
        (erase ["nixpkgs" "localSystem"])
        (erase ["nixpkgs" "crossSystem"])
        (erase ["nixpkgs" "pkgs"])
      ];
      config = {
        _module = {
          freeformType = l.types.unspecified;
          check = true;
        };
      };
      options = {
        _hive_erased = l.mkOption {
          type = l.types.listOf l.types.unspecified;
          internal = true;
          default = [];
        };
        bee = {
          system = l.mkOption {
            type = l.types.str;
            description = "divnix/hive requires you to set the host's system via 'config.bee.system = \"x86_64-linux\";'";
          };
          pkgs = l.mkOption {
            type = l.mkOptionType {
              name = "packages";
              description = "instance of nixpkgs";
              check = x: (l.isAttrs x) && (l.hasAttr "path" x);
            };
            description = "divnix/hive requires you to set the nixpkgs instance via 'config.bee.pkgs = inputs.nixos-22.05.legacyPackages;'";
            apply = x: x.${config.bee.system};
          };
        };
      };
    };

  checkAndTransformConfig = user: machine: config: let
    _file = "github:divnix/hive: ./comb/${user}; target: ${machine}";
    locatedConfig = {
      imports = [config];
      inherit _file;
    };
    checked = (evalModulesMinimal {modules = [combCheckModule locatedConfig];}).config;
    asserted = let
      failedAsserts = map (x: x.message) (l.filter (x: !x.assertion) checked._hive_erased);
    in
      if failedAsserts != []
      then throw "\nFailed assertions:\n${l.concatStringsSep "\n" (map (x: "- ${x}") failedAsserts)}"
      else checked;
  in
    (l.removeAttrs config ["_hive_erased" "bee"])
    // {
      inherit _file;
      nixpkgs = {inherit (asserted.bee) system pkgs;};
    };

  /*

  We start with:
        ${system}.${user}.${cellBlock}.${machine} = config;

            We want:
                  ${user}-o-${machine} = config; (filtered by system)

  */
  pasteurize = self:
    l.pipe
    (
      l.mapAttrs (system:
        l.mapAttrs (user: blocks: (
          l.pipe blocks [
            (l.attrByPath [cellBlock] {})
            (l.mapAttrs (machine: checkAndTransformConfig user machine))
            (l.filterAttrs (_: config: config.nixpkgs.system == system))
            (l.mapAttrs (machine: l.nameValuePair "${user}-o-${machine}"))
          ]
        )))
      (l.intersectAttrs (l.genAttrs l.systems.doubles.all (_: null)) self)
    ) [
      (l.collect (x: x ? name && x ? value))
      l.listToAttrs
    ];

  stir = config: {
    # we consume the already transformed contract here
    evalConfig = import (config.nixpkgs.pkgs.path + "/nixos/lib/eval-config.nix");
    system = config.nixpkgs.system;
  };
in {inherit pasteurize stir;}
