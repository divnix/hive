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
  Use the colmenaConfigurations Blocktype for
  final definitions of your NixOS hosts,
  including colmena-specific deployment config.
  */
  colmenaConfigurations = {
    name = "colmenaConfigurations";
    type = "colmenaConfiguration";
    # colmena action?
  };
in
  colmenaConfigurations
