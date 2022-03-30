{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles library;
in
  builtins.mapAttrs library.bearNixosConfiguration {
    larva = {
      imports = [nixosProfiles.bootstrap];
      # nixpkgs.system = "x86_64-linux";
    };
  }
