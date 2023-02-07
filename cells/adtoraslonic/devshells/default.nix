let
  l = nixpkgs.lib // builtins;

  inherit (inputs) nixpkgs std;
  inherit (std.lib) dev;

  withCategory = category: attrset: attrset // {inherit category;};
in
  l.mapAttrs (_: dev.mkShell) {
    default = {...}: {
      name = "Edgerunner Playgroud";
      nixago = with std.presets.nixago; [
        treefmt
        lefthook
        editorconfig
        (conform {configData = {inherit (inputs) cells;};})
      ];
      imports = [
        std.std.devshellProfiles.default
      ];
      commands = [
        (withCategory "hexagon" {package = inputs.nixpkgs.writedisk;})
        (withCategory "hexagon" {package = inputs.disko.packages.disko;})
        (withCategory "hexagon" {package = inputs.home.packages.home-manager;})
        (withCategory "hexagon" {package = inputs.colmena.packages.colmena;})
        (withCategory "hexagon" {package = inputs.agenix.packages.agenix;})
        (withCategory "hexagon" {package = inputs.nixos-generators.packages.nixos-generate;})
      ];
    };
  }
