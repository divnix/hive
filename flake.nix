# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
{
  description = "The Hive - The secretly open NixOS-Society";

  inputs.paisano.follows = "std/paisano";
  inputs.std = {
    url = "github:divnix/std";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.devshell.follows = "devshell";
    inputs.nixago.follows = "nixago";
  };

  inputs.devshell = {
    url = "github:numtide/devshell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixago = {
    url = "github:nix-community/nixago";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nixago-exts.follows = "";
  };

  # override downstream with inputs.hive.inputs.nixpkgs.follows = ...
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.colmena.url = "github:divnix/blank";

  outputs = {
    nixpkgs,
    std,
    paisano,
    colmena,
    nixago,
    devshell,
    self,
  } @ inputs: let
    inherit (std.inputs) haumea;
    hive = haumea.lib.load {
      src = ./src;
      loader = haumea.lib.loaders.scoped;
      inputs = removeAttrs (inputs // {inherit inputs;}) ["self"];
    };

    # compat wrapper for haumea.lib.load
    inherit (nixpkgs) lib;
    load = {
      inputs,
      cell,
      src,
    }:
    # modules/profiles are always functions
    args @ {
      config,
      pkgs,
      ...
    }: let
      cr = cell.__cr ++ [(baseNameOf src)];
      file = "${self.outPath}#${lib.concatStringsSep "/" cr}";

      defaultWith = let
        inherit
          (lib)
          functionArgs
          pipe
          toFunction
          ;
      in (importer: inputs: path: let
        f = toFunction (importer path);
      in
        pipe f [
          functionArgs
          (let
            context = name: ''while evaluating the argument `${name}' in "${file}":'';
          in
            builtins.mapAttrs (
              name: _:
                builtins.addErrorContext (context name)
                (inputs.${name} or config._module.args.${name})
            ))
          f
        ]);
      loader = inputs: defaultWith (scopedImport inputs) inputs;
      i = args // {inherit cell inputs;};
    in
      if lib.pathIsDirectory src
      then
        lib.setDefaultModuleLocation file (haumea.lib.load {
          inherit loader src;
          transformer = with haumea.lib.transformers; [
            liftDefault
            (hoistLists "_imports" "imports")
          ];
          inputs = i;
        })
      # Mimic haumea for a regular file
      else lib.setDefaultModuleLocation file (loader i src);

    findLoad = {
      inputs,
      cell,
      block,
    }:
      with builtins;
        lib.mapAttrs'
        (n: _:
          lib.nameValuePair
          (lib.removeSuffix ".nix" n)
          (load {
            inherit inputs cell;
            src = block + /${n};
          }))
        (removeAttrs (readDir block) ["default.nix"]);
  in
    paisano.growOn {
      inputs =
        inputs
        // {
          hive = {inherit findLoad;};
        };
      cellsFrom = ./aux;
      cellBlocks = [
        {
          type = "profiles";
          name = "profiles";
        }
        {
          type = "shell";
          name = "shell";
        }

        (std.blockTypes.nixago "configs")
        (std.blockTypes.devshells "shells" {ci.build = true;})
      ];
    }
    {
      inherit load findLoad;
      inherit (hive) blockTypes collect;
      inherit (paisano) grow growOn pick harvest winnow;
    }
    haumea.lib;
}
