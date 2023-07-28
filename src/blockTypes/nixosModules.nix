{
  nixpkgs,
  root,
}: let
  inherit
    (root)
    mkCommand
    ;

  l = nixpkgs.lib // builtins;

  nixosModules = {
    name = "nixosModules";
    type = "nixosModules";
    # nixosGenerator's actions?
    # microvm action?
    # nixos-rebuild action?
  };
in
  nixosModules
