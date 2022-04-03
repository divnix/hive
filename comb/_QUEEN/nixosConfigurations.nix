{
  inputs,
  cell,
}: let
  inherit (inputs) nixos-generators;
  inherit (cell) nixosProfiles library;
in
  builtins.mapAttrs library.bearNixosConfiguration {
    larva = {
      imports = [
        nixos-generators.nixosModules.install-iso
        nixosProfiles.bootstrap
      ];
      nixpkgs.system = "x86_64-linux";
    };
  }
