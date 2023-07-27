{
  inputs,
  nixpkgs,
  root,
}: let
  collectors =
    root.collectors
    // {
      /*
      Modules declare an interface into a problem domain
      */
      darwinModules = throw "not implemented yet";
      nixosModules = throw "not implemented yet";
      homeModules = throw "not implemented yet";
      shellModules = throw "not implemented yet";
      /*
      Profiles define values on that interface
      */
      hardwareProfiles = throw "not implemented yet";
      darwinProfiles = throw "not implemented yet";
      nixosProfiles = throw "not implemented yet";
      homeProfiles = throw "not implemented yet";
      shellProfiles = throw "not implemented yet";
      /*
      Suites aggregate profiles into groups
      */
      darwinSuites = throw "not implemented yet";
      nixosSuites = throw "not implemented yet";
      homeSuites = throw "not implemented yet";
      shellSuites = throw "not implemented yet";
    };
in {
  renamer = cell: target: "${cell}-${target}";
  __functor = self: Self: CellBlock:
    if builtins.hasAttr CellBlock collectors
    then collectors.${CellBlock} self.renamer Self
    else
      builtins.throw ''

        `hive.collect` can't collect ${CellBlock}.

        It can collect the following cell blocks:
         - ${builtins.concatStringsSep "\n - " (builtins.attrNames collectors)}
      '';
}
