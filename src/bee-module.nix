{nixpkgs}: let
  l = nixpkgs.lib // builtins;
  evalModulesMinimal = nixpkgs.lib.nixos.evalModules;

  beeModule = let
    erase = optionName: instruction: {options, ...}: let
      opt = l.getAttrFromPath optionName options;
    in {
      options = l.setAttrByPath optionName (l.mkOption {visible = false;});
      config.bee._alerts = [
        {
          assertion = !opt.isDefined;
          message = ''
            The option `${l.showOption optionName}' is not supported.
              Location: ${l.showFiles opt.files}
              ${
              if instruction != null
              then instruction
              else ""
            }
          '';
        }
      ];
    };
  in
    {config, ...}: {
      imports = [
        (erase ["nixpkgs" "config"] "Please set 'config.bee.pkgs' to a fully configured nixpkgs.")
        (erase ["nixpkgs" "overlays"] "Please set 'config.bee.pkgs' to a nixpkgs - overlays included.")
        (erase ["nixpkgs" "system"] "Please set 'config.bee.system', instead.")
        (erase ["nixpkgs" "localSystem"] "Please set 'config.bee.system', instead.")
        (erase ["nixpkgs" "crossSystem"] "Please set 'config.bee.system', instead.")
        (erase ["nixpkgs" "pkgs"] "Please set 'config.bee.pkgs' to an instantiated version of nixpkgs.")
      ];
      options.bee = {
        _alerts = l.mkOption {
          type = l.types.listOf l.types.unspecified;
          internal = true;
          default = [];
        };
        _evaled = l.mkOption {
          type = l.types.attrs;
          internal = true;
          default = {};
        };
        _unchecked = l.mkOption {
          type = l.types.attrs;
          internal = true;
          default = {};
        };
        system = l.mkOption {
          type = l.types.str;
          description = "divnix/hive requires you to set the host's system via 'config.bee.system = \"x86_64-linux\";'";
        };
        home = l.mkOption {
          type = l.mkOptionType {
            name = "input";
            description = "home-manager input";
            check = x: (l.isAttrs x) && (l.hasAttr "sourceInfo" x);
          };
          description = "divnix/hive requires you to set the home-manager input via 'config.bee.home = inputs.home-22-05;'";
        };
        wsl = l.mkOption {
          type = l.mkOptionType {
            name = "input";
            description = "nixos-wsl input";
            check = x: (l.isAttrs x) && (l.hasAttr "sourceInfo" x);
          };
          description = "divnix/hive requires you to set the home-manager input via 'config.bee.wsl = inputs.nixos-wsl;'";
        };
        darwin = l.mkOption {
          type = l.mkOptionType {
            name = "input";
            description = "darwin input";
            check = x: (l.isAttrs x) && (l.hasAttr "sourceInfo" x);
          };
          description = "divnix/hive requires you to set the darwin input via 'config.bee.darwin = inputs.darwin;'";
        };
        pkgs = l.mkOption {
          type = l.mkOptionType {
            name = "packages";
            description = "instance of nixpkgs";
            check = x: (l.isAttrs x) && (l.hasAttr "path" x);
          };
          description = "divnix/hive requires you to set the nixpkgs instance via 'config.bee.pkgs = inputs.nixos-22.05.legacyPackages;'";
          apply = x:
            if (l.hasAttr "${config.bee.system}" x)
            then x.${config.bee.system}
            else x;
        };
      };
    };

  checkBeeAnd = tranform: locatedConfig: let
    checked = evalModulesMinimal {
      modules = [
        locatedConfig
        beeModule
        {
          config._module.check = true;
          config._module.freeformType = l.types.unspecified;
        }
      ];
    };

    failedAsserts = map (x: x.message) (l.filter (x: !x.assertion) checked.config.bee._alerts);

    asserted =
      if failedAsserts != []
      then throw "\nHive's layer sanitation boundary: \n${l.concatStringsSep "\n" (map (x: "- ${x}") failedAsserts)}"
      else checked;
  in
    tranform asserted locatedConfig;

  tranformToNixosConfig = evaled: locatedConfig: let
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
    eval = extra:
      import (evaled.config.bee.pkgs.path + "/nixos/lib/eval-config.nix") {
        # signal to use nixpkgs.system before: https://github.com/NixOS/nixpkgs/pull/220743
        system = null;
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
    imports = [beeModule locatedConfig extraConfig] ++ nixosModules;
  };

  tranformToDarwinConfig = evaled: locatedConfig: let
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
    imports = [beeModule locatedConfig extraConfig] ++ darwinModules;
  };

  tranformToHomeManagerConfig = evaled: locatedConfig: let
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
  };
in {
  inherit
    beeModule
    checkBeeAnd
    tranformToNixosConfig
    tranformToDarwinConfig
    tranformToHomeManagerConfig
    ;
}
