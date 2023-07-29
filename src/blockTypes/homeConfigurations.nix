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
  Use the homeConfigurations Blocktype for
  final definitions of your HomeManager environments.
  */
  homeConfigurations = {
    name = "homeConfigurations";
    type = "homeConfiguration";
    # homemanager's actions?
  };
in
  homeConfigurations
