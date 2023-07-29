{
  inputs, # unused for now
  nixpkgs,
  root,
  super,
}: cellBlock: renamer: let
  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano transformers collectorOps;

  walk = flakeRoot:
    walkPaisano.root
    flakeRoot
    cellBlock
    (collectorOps.nixosConfigurations flakeRoot cellBlock "nixosModules" "nixosProfiles" transformers.${cellBlock} renamer)
    renamer;
in
  walk
