{
  description = "The Hive - The secretly open NixOS-Society";
  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.yants.follows = "std/yants";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.data-merge.url = "github:divnix/data-merge";

  # tools
  inputs = {
    n2c.url = "github:nlewo/nix2container";
    nixos-generators.url = "github:nix-community/nixos-generators";
  };

  # nixpkgs & home-manager
  inputs = {
    nixos.follows = "nixos-21-11";
    home.follows = "home-21-11";

    nixos-21-11.url = "github:nixos/nixpkgs/release-21.11";
    home-21-11.url = "github:blaggacao/home-manager/release-21.11-with-nix-profile";
  };

  # individual inputs
  inputs = {
    iog-patched-nix.url = "github:kreisys/nix/goodnix-maybe-dont-functor";
  };

  outputs = inputs: let
    # exports have no system, pick one
    exports = inputs.self.x86_64-linux;
  in
    inputs.std.growOn {
      inherit inputs;
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
        (inputs.std.data "colmenaConfigurations")
        (inputs.std.data "homeConfigurations")

        # devshells can be entered
        (inputs.std.devshells "devshells")

        # jobs can be run
        (inputs.std.runnables "jobs")

        # library holds shared knowledge made code
        (inputs.std.functions "library")
      ];
    }
    # soil - the first (and only) layer implements adapters for tooling
    {
      # tool: colmena
      colmena = let
        inherit (inputs.nixpkgs.lib.attrsets) foldAttrs recursiveUpdate mapAttrsToList mapAttrs';
        inherit (inputs.nixpkgs.lib.lists) optionals flatten map;
        inherit (builtins) attrValues;
        collect = x:
          foldAttrs recursiveUpdate {} (flatten (mapAttrsToList (
              cell: organelles:
                optionals (organelles ? colmenaConfigurations)
                (map (mapAttrs' (name: value: {
                  name =
                    if name != "meta"
                    then "${cell}-o-${name}"
                    else name;
                  value =
                    if name == "meta" && (value ? nodeNixpkgs)
                    then
                      (
                        value
                        // {
                          nodeNixpkgs =
                            mapAttrs' (
                              name: value: {
                                name = "${cell}-o-${name}";
                                inherit value;
                              }
                            )
                            value.nodeNixpkgs;
                        }
                      )
                    else value;
                })) (attrValues organelles.colmenaConfigurations))
            )
            x));
      in
        collect exports;
    };

  # --- Flake Local Nix Configuration ----------------------------
  # TODO: adopt spongix
  nixConfig = {
    extra-substituters = [];
    extra-trusted-public-keys = [];
  };
  # --------------------------------------------------------------
}
