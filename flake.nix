# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
{
  description = "The Hive - The secretly open NixOS-Society";

  inputs.paisano = {
    url = "github:divnix/paisano";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # override downstream with inputs.hive.inputs.nixpkgs.follows = ...
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  inputs = {
    colmena.url = "github:divnix/blank";
    disko.url = "github:divnix/blank";
    nixos-generators.url = "github:divnix/blank";
    home-manager.url = "github:divnix/blank";
    haumea.url = "github:nix-community/haumea?ref=v0.2.1";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    blockTypes = import ./src/blocktypes.nix {inherit (inputs) nixpkgs;};
    collect = import ./src/collect.nix {
      inherit inputs;
      inherit (inputs) nixpkgs;
    };
    # compat wrapper for humea.lib.load
    inherit (inputs) haumea;
    load = {
      inputs,
      cell,
      ...
    } @ args:
      with builtins;
        haumea.lib.load (removeAttrs args ["cell" "inputs"]
          // {
            loader = haumea.lib.loaders.scoped;
            transformer = with haumea.lib.transformers; [
                liftDefault
                (hoistLists "_imports" "imports")
            ];
            # `self` in paisano refers to `inputs.self.sourceInfo` 😕
            # but is disallowed in haumea
            inputs = removeAttrs (inputs // {inherit inputs cell;}) ["self"];
          });
  in
    haumea.lib
    // {
      inherit blockTypes collect load;
      inherit (inputs.paisano) grow growOn pick harvest winnow;
    };
}
