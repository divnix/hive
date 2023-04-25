{
  nixpkgs,
  mkCommand,
}: let
  l = nixpkgs.lib // builtins;
  /*
  Use the darwinConfigurations Blocktype for
  final definitions of your Darwin hosts.
  */
  darwinConfigurations = {
    name = "darwinConfigurations";
    type = "darwinConfiguration";
    # darwin-rebuild action?
  };
in
  darwinConfigurations
