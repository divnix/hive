{
  description = "The Hive - The secretly open NixOS-Society";
  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  # tools
  inputs = {
    nixos-generators.url = "github:nix-community/nixos-generators";
  };

  # nixpkgs & home-manager
  inputs = {
    nixos.follows = "nixos-22-05";
    home.follows = "home-22-05";

    nixos-22-05.url = "github:nixos/nixpkgs/release-22.05";
    home-22-05.url = "github:nix-community/home-manager/release-22.05";
    nixos-21-11.url = "github:nixos/nixpkgs/release-21.11";
    home-21-11.url = "github:blaggacao/home-manager/release-21.11-with-nix-profile";
  };

  # individual inputs
  inputs = {
    iog-patched-nix.url = "github:kreisys/nix/goodnix-maybe-dont-functor";
  };

  outputs = {
    std,
    self,
    ...
  } @ inputs: let
    # exports have no system, pick one
    exports = self.x86_64-linux;
  in
    std.growOn {
      inherit inputs;
      cellsFrom = ./comb;
      # debug = ["cells" "x86_64-linux"];
      cellBlocks = with std.blockTypes; [
        # modules implement
        (functions "nixosModules")
        (functions "homeModules")
        (functions "devshellModules")

        # profiles activate
        (functions "nixosProfiles")
        (functions "homeProfiles")
        (functions "devshellProfiles")

        # suites aggregate profiles
        (functions "nixosSuites")
        (functions "homeSuites")

        # configurations can be deployed
        (data "colmenaConfigurations")
        (data "homeConfigurations")

        # devshells can be entered
        (devshells "devshells")

        # jobs can be run
        (runnables "jobs")

        # library holds shared knowledge made code
        (functions "library")
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
