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
    hive = haumea.lib.load {
      src = ./src;
      loader = haumea.lib.loaders.scoped;
      inputs = removeAttrs (inputs // {inherit inputs;}) ["self"];
    };

    # compat wrapper for humea.lib.load
    inherit (inputs) haumea;
    load = {
      inputs,
      cell,
      src,
    }:
    # modules/profiles are always functions
    {config, options, ...}:
      haumea.lib.load {
        inherit src;
        loader = haumea.lib.loaders.scoped;
        transformer = with haumea.lib.transformers; [
          liftDefault
          (hoistLists "_imports" "imports")
        ];
        inputs = {inherit inputs cell config options;};
      };
  in
    haumea.lib
    // {
      inherit load;
      inherit (hive) blockTypes collect;
      inherit (inputs.paisano) grow growOn pick harvest winnow;
    };
}
