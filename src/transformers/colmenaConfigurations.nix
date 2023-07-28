{
  nixpkgs,
  root,
}: name: {
  evaled,
  locatedConfig,
  locatedModules,
  locatedProfiles,
} @ checkOutput: let
  inherit (root) transformers;

  config = {
    imports = [locatedConfig] ++ colmenaModules;
    _modules.args = {inherit name;};
  };
in
  transformers.nixosConfigurations (checkOutput
    // {
      locatedConfig = config;
    })
