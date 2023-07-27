{
  nixpkgs,
  root,
}: let
  inherit
    (root)
    mkCommand
    ;

  l = nixpkgs.lib // builtins;
  /*
  Use the nixosConfigurations Blocktype for
  final definitions of your NixOS hosts.
  */
  nixosConfigurations = {
    name = "nixosConfigurations";
    type = "nixosConfiguration";
    # nixosGenerator's actions?
    # microvm action?
    # nixos-rebuild action?
  };
in
  nixosConfigurations
