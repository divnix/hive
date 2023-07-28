{
  nixpkgs,
  root,
}: let
  inherit
    (root)
    mkCommand
    ;

  l = nixpkgs.lib // builtins;

  darwinModules = {
    name = "darwinModules";
    type = "darwinModules";
    # nixosGenerator's actions?
    # microvm action?
    # nixos-rebuild action?
  };
in
  darwinModules
