let
  l = nixpkgs.lib // builtins;

  inherit (inputs) nixpkgs std;
  inherit (std.lib) dev;

  withCategory = category: attrset: attrset // {inherit category;};
in
  l.mapAttrs (_: dev.mkShell) {
    default = {...}: {
      name = "Apis Mellifera";
      nixago = with std.presets.nixago; [
        treefmt
        lefthook
        editorconfig
        (conform {configData = {inherit (inputs) cells;};})
      ];
      imports = [];
      commands = [
        (withCategory "hexagon" {package = inputs.nixpkgs.writedisk;})
        (withCategory "hexagon" {package = inputs.home.packages.home-manager;})
        (withCategory "hexagon" {package = inputs.colmena.packages.colmena;})
        (withCategory "hexagon" {package = inputs.nixos-generators.packages.nixos-generate;})
        (withCategory "hexagon" {
          name = "build-larva";
          help = "the hive x86_64-linux iso-bootstrapper";
          command = ''
            nix build $PRJ_ROOT#nixosConfigurations._QUEEN-o-larva.config.system.build.isoImage
          '';
        })
      ];
    };
  }
