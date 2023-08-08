{
  inputs,
  nixpkgs,
  root,
}: {
  evaled,
  locatedConfig,
}: let
  l = nixpkgs.lib // builtins;

  inherit (root) beeModule transformers;
  inherit (inputs) colmena;

  colmenaModules = l.map (l.setDefaultModuleLocation (./colmenaConfigurations.nix + ":colmenaModules")) [
    # these modules are tied to the below schemaversion
    # so we fix them here
    colmena.nixosModules.assertionModule
    colmena.nixosModules.keyChownModule
    colmena.nixosModules.keyServiceModule
    colmena.nixosModules.deploymentOptions
    {
      environment.etc."nixos/configuration.nix".text = ''
        throw '''
          This machine is not managed by nixos-rebuild, but by colmena.
        '''
      '';
    }
  ];

  config = {
    imports = [locatedConfig] ++ colmenaModules;
  };
in transformers.nixosConfigurations {inherit evaled; locatedConfig = config;}
