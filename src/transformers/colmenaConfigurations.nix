{
  inputs,
  nixpkgs,
  root,
}: name: {
  evaled,
  locatedConfig,
  locatedModules,
  locatedProfiles,
} @ checkOutput: let
  l = nixpkgs.lib // builtins;

  inherit (root) transformers;

  colmenaModules = l.map (l.setDefaultModuleLocation (./collect-colmena.nix + ":colmenaModules")) [
    # these modules are tied to the below schemaversion
    # so we fix them here
    inputs.colmena.nixosModules.assertionModule
    inputs.colmena.nixosModules.keyChownModule
    inputs.colmena.nixosModules.keyServiceModule
    inputs.colmena.nixosModules.deploymentOptions
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
    _modules.args = {inherit name;};
  };
in
  transformers.nixosConfigurations (checkOutput
    // {
      locatedConfig = config;
    })
