let
  inherit (inputs.std.lib.dev) mkShell;
  inherit (cell) configs;
  inherit (inputs.nixpkgs.lib) mapAttrs;
in
  mapAttrs (_: mkShell) rec {
    default = {...}: {
      name = "Hive";
      nixago = [
        configs.conform
        configs.treefmt
        configs.editorconfig
        configs.githubsettings
        configs.lefthook
        configs.cog
      ];
    };
  }
