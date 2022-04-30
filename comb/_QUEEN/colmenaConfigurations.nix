{
  inputs,
  cell,
}: let
  inherit (inputs) nixos-generators nixos;
  inherit (cell) nixosProfiles library;
in
  builtins.mapAttrs (library.lay nixos.legacyPackages.x86_64-linux) {
    larva = {
      deployment = {
        targetHost = "fe80::47";
        targetPort = 22;
        targetUser = "root";
      };
      imports = [
        nixos-generators.nixosModules.install-iso
        nixosProfiles.bootstrap
      ];
    };
  }
