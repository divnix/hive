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

  nixosModules = import (evaled.config.bee.pkgs.path + "/nixos/modules/module-list.nix");
  extraConfig = {
    nixpkgs = {
      inherit (evaled.config.bee) system pkgs;
      inherit (evaled.config.bee.pkgs) config; # nixos modules don't load this
    };

    imports =
      # seemlessly integrate hm if desired
      l.optionals evaled.options.bee.home.isDefined [
        evaled.config.bee.home.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ]
      # seemlessly integrate nixos-wsl if desired
      ++ l.optionals evaled.options.bee.wsl.isDefined [
        evaled.config.bee.wsl.nixosModules.wsl
        {
          wsl.enable = l.mkDefault true;
        }
      ];
  };

  evalModules = [beeModule locatedConfig extraConfig];
  eval = extra:
    import (evaled.config.bee.pkgs.path + "/nixos/lib/eval-config.nix") {
      # signal to use nixpkgs.system before: https://github.com/NixOS/nixpkgs/pull/220743
      system = null;
      modules = evalModules ++ [extra];
      pkgs = evaled.config.bee.pkgs;
      extraModules = locatedModules ++ locatedProfiles;
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
  imports = evalModules ++ nixosModules;
}
