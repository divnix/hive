{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
  withCategory = category: attrset: attrset // {inherit category;};
in
  l.mapAttrs (_: std.lib.dev.mkShell) {
    default = {
      extraModulesPath,
      pkgs,
      ...
    }: {
      name = "Apis Mellifera";
      std.docs.enable = false;
      git.hooks = {
        enable = true;
        pre-commit.text = builtins.readFile ./pre-flight-check.sh;
      };
      imports = [
        std.std.devshellProfiles.default
        "${extraModulesPath}/git/hooks.nix"
      ];
      commands = [
        (withCategory "hexagon" {package = nixpkgs.treefmt;})
        # (withCategory "hexagon" {package = nixpkgs.colmena;})
        (withCategory "hexagon" {
          name = "build-larva";
          help = "the hive x86_64-linux iso-bootstrapper";
          command = ''
            nix build $PRJ_ROOT#x86_64-linux._QUEEN.nixosConfigurations.larva.config.system.build.isoImage
          '';
        })
      ];
      packages = [
        # formatters
        nixpkgs.alejandra
        nixpkgs.nodePackages.prettier
        nixpkgs.nodePackages.prettier-plugin-toml
        nixpkgs.shfmt
        nixpkgs.editorconfig-checker
      ];
      devshell.startup.nodejs-setuphook =
        l.stringsWithDeps.noDepEntry
        ''
          export NODE_PATH=${nixpkgs.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH
        '';
    };
  }
