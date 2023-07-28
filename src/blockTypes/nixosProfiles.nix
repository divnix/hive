{
  nixpkgs,
  root,
}: let
  inherit
    (root)
    mkCommand
    ;

  l = nixpkgs.lib // builtins;

  nixosProfiles = {
    name = "nixosProfiles";
    type = "nixosProfiles";
    # nixosGenerator's actions?
    # microvm action?
    # nixos-rebuild action?
  };
in
  nixosProfiles
