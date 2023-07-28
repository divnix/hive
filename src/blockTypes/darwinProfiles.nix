{
  nixpkgs,
  root,
}: let
  inherit
    (root)
    mkCommand
    ;

  l = nixpkgs.lib // builtins;

  darwinProfiles = {
    name = "darwinProfiles";
    type = "darwinProfiles";
    # nixosGenerator's actions?
    # microvm action?
    # nixos-rebuild action?
  };
in
  darwinProfiles
