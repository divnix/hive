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
  name = "nixosModules";
  type = "nixosModules";
  # nixosGenerator's actions?
  # microvm action?
  # nixos-rebuild action?
}
