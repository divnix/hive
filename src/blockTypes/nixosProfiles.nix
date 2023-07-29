{
  nixpkgs,
  root,
  super,
}: let
  inherit
    (root)
    mkCommand
    ;
in {
  __functor = super.addSelectorToFunctor;
  name = "nixosProfiles";
  type = "nixosProfiles";
  # nixosGenerator's actions?
  # microvm action?
  # nixos-rebuild action?
}
