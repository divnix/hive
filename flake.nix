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
  };

  outputs = inputs: let
    blockTypes = import ./src/blocktypes.nix {inherit (inputs) nixpkgs;};
    collect = import ./src/collect.nix {
      inherit inputs;
      inherit (inputs) nixpkgs;
    };
  in {
    inherit blockTypes collect;
    inherit (inputs.paisano) grow growOn pick harvest winnow;
  };
}
