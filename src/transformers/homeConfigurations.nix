{
  nixpkgs,
  root,
}: {
  evaled,
  locatedConfig,
}: let
  l = nixpkgs.lib // builtins;

  inherit (root) beeModule;

  lib = import (evaled.config.bee.home + /modules/lib/stdlib-extended.nix) l;
  hmModules = import (evaled.config.bee.home + /modules/modules.nix) {
    inherit (evaled.config.bee) pkgs;
    inherit lib;
    check = true;
    # we switch off the nixpkgs module, package instantiation needs
    # to happen on the `std` layer
    useNixpkgsModule = false;
  };
  eval = extra:
    lib.evalModules {
      specialArgs = {
        modulesPath = l.toString (evaled.config.bee.home + /modules);
      };
      modules = [beeModule locatedConfig extra] ++ hmModules;
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
  imports = [beeModule locatedConfig] ++ hmModules;
}
