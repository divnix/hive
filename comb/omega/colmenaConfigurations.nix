{
  inputs,
  cell,
}: let
  inherit (inputs) nixos;
  inherit (inputs.cells) _QUEEN;
in
  builtins.mapAttrs (_QUEEN.library.lay nixos.legacyPackages.x86_64-linux) {
    blacklion = {
      imports = [./nixosConfigurations/blacklion];
    };
  }
