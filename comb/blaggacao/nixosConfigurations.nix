{
  inputs,
  cell,
}: let
  inherit (inputs.cells) _QUEEN;

  inherit (cell.nixosProfiles) iog-patched-nix;
in
  builtins.mapAttrs _QUEEN.library.bearNixosConfiguration {
    ws = {nixpkgs.system = "x86_64-linux";};
  }
