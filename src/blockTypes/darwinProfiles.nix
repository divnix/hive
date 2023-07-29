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
  name = "darwinProfiles";
  type = "darwinProfiles";
  # nixosGenerator's actions?
  # microvm action?
  # nixos-rebuild action?
}
