{
  description = "The Hive - The secretly open NixOS-Society";
  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.yants.follows = "std/yants";
  inputs.nixpkgs.follows = "std/nixpkgs";
  inputs.data-merge.url = "github:divnix/data-merge";

  # tools
  inputs = {
    n2c.url = "github:nlewo/nix2container";
    deploy-rs.url = "github:input-output-hk/deploy-rs";
  };

  # nixpkgs & home-manager
  inputs = {
    nixos.follows = "nixos-21-11";
    home.follows = "home-21-11";

    nixos-21-11.url = "github:nixos/nixpkgs/nixos-21.11";
    home-21-11.url = "github:blaggacao/home-manager/release-21.11-with-nix-profile";
  };

  # individual inputs
  inputs = {
    iog-patched-nix.url = "github:kreisys/nix/goodnix-maybe-dont-functor";
  };

  outputs = inputs:
    inputs.std.growOn {
      inherit inputs;
      as-nix-cli-epiphyte = false;
      cellsFrom = ./comb;
      # debug = ["cells" "x86_64-linux"];
      organelles = [
        # modules implement
        (inputs.std.functions "nixosModules")
        (inputs.std.functions "homeModules")
        (inputs.std.functions "devshellModules")

        # profiles activate
        (inputs.std.functions "nixosProfiles")
        (inputs.std.functions "homeProfiles")
        (inputs.std.functions "devshellProfiles")

        # suites aggregate profiles
        (inputs.std.functions "nixosSuites")
        (inputs.std.functions "homeSuites")

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
      deploy.nodes =
        # this library function is not _actually_ system spaced
        inputs.self.x86_64-linux._QUEEN.library.bearDeployConfigurations;

      # tool: nixos-generators
      nixosConfigurations =
        # this library function is not _actually_ system spaced
        inputs.self.x86_64-linux._QUEEN.library.summonNixosConfigurations;
    };

  # --- Flake Local Nix Configuration ----------------------------
  # TODO: adopt spongix
  nixConfig = {
    extra-substituters = [];
    extra-trusted-public-keys = [];
  };
  # --------------------------------------------------------------
}
