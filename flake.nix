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
    {
      config,
      options,
      ...
    }: let
      cr = cell.__cr ++ [(baseNameOf src)];
      file = "${self.outPath}#${lib.concatStringsSep "/" cr}";

      defaultWith = import (haumea + /src/loaders/__defaultWith.nix) {inherit lib;};
      loader = let i = {inherit inputs cell config options;}; in defaultWith (scopedImport i) i;
    in
      if lib.pathIsDirectory src
      then
        lib.setDefaultModuleLocation file (haumea.lib.load {
          inherit src;
          loader = haumea.lib.loaders.scoped;
          transformer = with haumea.lib.transformers; [
            liftDefault
            (hoistLists "_imports" "imports")
          ];
          inputs = {inherit inputs cell config options;};
        })
      # Mimic haumea for a regular file
      else lib.setDefaultModuleLocation file (loader src);

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
          type = "pkgsFunc";
          name = "pkgsFunc";
        }
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
    (removeAttrs haumea.lib ["load"])
    {
      inherit load findLoad;
      inherit (hive) blockTypes collect;
      inherit (paisano) grow growOn pick harvest winnow;
    };
}
