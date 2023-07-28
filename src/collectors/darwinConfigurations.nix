{
  inputs, # unused for now
  nixpkgs,
  root,
  super,
}: let
  inherit (root) transformers;
in
  super.nixosConfigurations
  // {
    modulesCellBlock = "darwinModules";
    profilesCellBlock = "darwinProfiles";
    transformer = transformers.darwinConfigurations;
  }
