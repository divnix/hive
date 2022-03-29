{
  description = "The Hive - The secretly open NixOS-Society";
  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.yants.follows = "std/yants";
  inputs.data-merge.url = "github:divnix/data-merge";

  # tools
  inputs = {
    n2c.url = "github:nlewo/nix2container";
    nixos-generators.url = "github:nix-community/nixos-generators";
    deploy-rs.url = "github:input-output-hk/deploy-rs";
  };

  # nixpkgs
  inputs = {
    nixos-21-11.url = "github:nixos/nixpkgs/nixos-21.11";
  };

  outputs = inputs:
    inputs.std.growOn {
      inherit inputs;
      as-nix-cli-epiphyte = false;
      cellsFrom = ./comb;
      # debug = ["cells" "queen" "library"];
      organelles = [
        # modules implement
        (inputs.std.functions "nixosModules")
        (inputs.std.functions "homeModules")
        (inputs.std.functions "devshellModules")

        # profiles activate
        (inputs.std.functions "nixosProfiles")
        (inputs.std.functions "homeProfiles")
        (inputs.std.functions "devshellProfiles")

        # configurations can be deployed
        (inputs.std.data "nixosConfigurations")
        (inputs.std.data "homeConfigurations")

        # devshells can be entered
        (inputs.std.installables "devShells")

        # jobs can be run
        (inputs.std.runnables "jobs")

        # library holds shared knowledge made code
        (inputs.std.functions "library")
      ];
    }
    # soil - the first (and only) layer implements adapters for tooling
    {
      # tool: deploy-rs
      deploy = {};

      # tool: nixos-generators
      nixosConfigurations = {};
    };

  # --- Flake Local Nix Configuration ----------------------------
  # TODO: adopt spongix
  nixConfig = {
    extra-substituters = [];
    extra-trusted-public-keys = [];
  };
  # --------------------------------------------------------------
}
