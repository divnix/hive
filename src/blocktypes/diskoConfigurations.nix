{
  nixpkgs,
  mkCommand,
}: let
  l = nixpkgs.lib // builtins;
  /*
  Use the diskoConfigurations Blocktype for
  final definitions of your standalone disko
  formatting configurations / profiles.
  */
  diskoConfigurations = {
    name = "diskoConfigurations";
    type = "diskoConfiguration";
    # disko's CLI actions?
    # maybe even more things, like remote formatting commands?
  };
in
  diskoConfigurations
