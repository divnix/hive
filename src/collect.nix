{
  inputs,
  nixpkgs,
}: let
  requireInput = import ./requireInput.nix {inherit inputs;};
  dispatch = {
    /*
    Modules declare an interface into a problem domain
    */
    nixosModules = throw "not implemented yet";
    homeModules = throw "not implemented yet";
    shellModules = throw "not implemented yet";
    /*
    Profiles define values on that interface
    */
    hardwareProfiles = throw "not implemented yet";
    nixosProfiles = throw "not implemented yet";
    homeProfiles = throw "not implemented yet";
    shellProfiles = throw "not implemented yet";
    /*
    Suites aggregate profiles into groups
    */
    nixosSuites = throw "not implemented yet";
    homeSuites = throw "not implemented yet";
    shellSuites = throw "not implemented yet";
    /*
    Configurations have an init-sequence and can be deployed
    */
    nixosConfigurations = import ./collect-nixos.nix {
      cellBlock = "nixosConfigurations";
      inherit nixpkgs inputs;
    };
    colmenaConfigurations = import ./collect-colmena.nix {
      cellBlock = "colmenaConfigurations";
      inherit nixpkgs;
      inputs = requireInput "colmena" "github:zhaofengli/colmena" "collect \"colmenaConfigurations\"";
    };
    homeConfigurations = import ./collect-home.nix {
      cellBlock = "homeConfigurations";
      inherit nixpkgs inputs;
    };
    diskoConfigurations = import ./collect-disko.nix {
      cellBlock = "diskoConfigurations";
      inherit nixpkgs inputs;
    };
  };
in {
  renamer = cell: target: "${cell}-${target}";
  __functor = self: Self: CellBlock:
    if builtins.hasAttr CellBlock dispatch
    then dispatch.${CellBlock} self.renamer Self
    else
      builtins.throw ''

        `hive.collect` can't collect ${CellBlock}.

        It can collect the following cell blocks:
         - ${builtins.concatStringsSep "\n - " (builtins.attrNames dispatch)}
      '';
}
