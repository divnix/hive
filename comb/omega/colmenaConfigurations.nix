{
  inputs,
  cell,
}: let
  inherit (inputs) nixos;
  inherit (inputs.cells) _QUEEN;

  inherit (cell.nixosProfiles) iog-patched-nix;
in
  builtins.mapAttrs (_QUEEN.library.lay nixos.legacyPackages.x86_64-linux) {
    blacklion = {
      imports = [iog-patched-nix ./nixosConfigurations/blacklion];
    };
  }
