{nixpkgs}: let
  l = nixpkgs.lib // builtins;

  inherit (root) beeModule;

  check = locatedModules: locatedProfiles: locatedConfig: let
    checked = l.nixos.evalModules {
      modules =
        [
          locatedConfig
          beeModule
          {
            config._module.check = true;
            config._module.freeformType = l.types.unspecified;
          }
        ]
        ++ locatedModules
        ++ locatedProfiles;
    };

    failedAsserts = map (x: x.message) (l.filter (x: !x.assertion) checked.config.bee._alerts);

    asserted =
      if failedAsserts != []
      then throw "\nHive's layer sanitation boundary: \n${l.concatStringsSep "\n" (map (x: "- ${x}") failedAsserts)}"
      else checked;
  in
    assert l.isAttrs asserted; {
      inherit locatedConfig locatedModules locatedProfiles;
      evaled = asserted;
    };
in
  check
