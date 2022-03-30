{
  description = "Hony from The Hive";
  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.deploy-rs.url = "github:input-output-hk/deploy-rs";
  outputs = inputs:
    inputs.flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] (
      system: let
        inherit (inputs.std) deSystemize;
        inherit
          (deSystemize system inputs)
          std
          deploy-rs
          devshell
          ;
        inherit (deSystemize system std.inputs) nixpkgs;
        withCategory = category: attrset: attrset // {inherit category;};
      in {
        devShells.mellifera = devshell.legacyPackages.mkShell (
          {
            extraModulesPath,
            pkgs,
            ...
          }: {
            name = "Apis Mellifera";
            git.hooks = {
              enable = true;
              pre-commit.text = builtins.readFile ./pre-flight-check.sh;
            };
            imports = [
              std.std.devshellProfiles.default
              "${extraModulesPath}/git/hooks.nix"
            ];
            cellsFrom = "./comb";
            commands = [
              (withCategory "hexagon" {package = nixpkgs.legacyPackages.treefmt;})
              (withCategory "hexagon" {package = deploy-rs.packages.deploy-rs;})
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
              nixpkgs.legacyPackages.alejandra
              nixpkgs.legacyPackages.nodePackages.prettier
              nixpkgs.legacyPackages.nodePackages.prettier-plugin-toml
              nixpkgs.legacyPackages.shfmt
              nixpkgs.legacyPackages.editorconfig-checker
            ];
            devshell.startup.nodejs-setuphook =
              nixpkgs.lib.stringsWithDeps.noDepEntry
              ''
                export NODE_PATH=${nixpkgs.legacyPackages.nodePackages.prettier-plugin-toml}/lib/node_modules:$NODE_PATH
              '';
          }
        );
      }
    );
}
