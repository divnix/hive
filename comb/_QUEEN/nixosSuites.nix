let
  inherit (cell) nixosProfiles;
in {
  larva = {
    imports = [
      nixosProfiles.bootstrap
    ];
  };
}
