{
  nixpkgs,
  root,
}: {
  evaled,
  locatedConfig,
  locatedModules,
  locatedProfiles,
}: let
  l = nixpkgs.lib // builtins;

  inherit (root) beeModule;

  darwinModules =
    import (evaled.config.bee.darwin + "/modules/module-list.nix")
    ++ [
      evaled.options.bee.darwin.darwinModules.flakeOverrides
    ];
  extraConfig = {
    # seemlessly integrate hm if desired
    imports = l.optionals evaled.options.bee.home.isDefined [
      evaled.config.bee.home.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  evalModules = [beeModule locatedConfig extraConfig] ++ locatedModules ++ locatedProfiles;
  eval = extra:
    evaled.config.bee.darwin.lib.darwinSystem {
      inherit (evaled.config.bee) system pkgs;
      modules = [beeModule locatedConfig extraConfig extra];
    };
  bee =
    evaled.config.bee
    // {
      _evaled = eval {config._module.check = true;};
      _unchecked = eval {config._module.check = false;};
    };
in {
  inherit bee;
  # complete module set, can be lib.evalModuled as-is
  imports = evalModules ++ darwinModules;
}
