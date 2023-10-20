{
  inputs,
  nixpkgs,
  root,
}: {
  evaled,
  locatedConfig,
}: let
  l = nixpkgs.lib // builtins;
  inherit (root) transformers;
  inherit (inputs) colmena;

  isDarwin = evaled.config.bee.pkgs.stdenv.isDarwin;

  colmenaModules =
    l.map (l.setDefaultModuleLocation (./colmenaConfigurations.nix + ":colmenaModules")) [
      # these modules are tied to the below schemaversion
      # so we fix them here
      colmena.nixosModules.assertionModule
      colmena.nixosModules.keyChownModule
      colmena.nixosModules.deploymentOptions
      {
        environment.etc."nixos/configuration.nix".text = ''
          throw '''
            This machine is not managed by nixos-rebuild, but by colmena.
          '''
        '';
      }
    ]
    ++ (l.optionals (!isDarwin) [colmena.nixosModules.keyServiceModule]);

  config = {
    imports = [locatedConfig] ++ colmenaModules;
  };
in
  if isDarwin
  then
    transformers.darwinConfigurations {
      inherit evaled;
      locatedConfig = config;
    }
  else
    transformers.nixosConfigurations {
      inherit evaled;
      locatedConfig = config;
    }
