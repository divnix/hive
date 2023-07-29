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
  name = "darwinModules";
  type = "darwinModules";
  # nixosGenerator's actions?
  # microvm action?
  # nixos-rebuild action?
}
