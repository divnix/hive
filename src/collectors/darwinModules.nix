{
  inputs,
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "darwinModules";

  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano checks;

  walk = self:
    walkPaisano self cellBlock (system: cell: [
      (l.mapAttrs (target: module: ({
          config,
          lib,
          ...
        } @ moduleInputs: let
          evaled = module (renamer cell target) moduleInputs;
        in {
          options.bee.modules."${renamer cell target}" =
            {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "En-/Disable module ${renamer cell target}";
              };
            }
            // evaled.options;
          config = lib.mkIf (config.bee.modules."${renamer cell target}".enable) evaled.config;
        })))
    ])
    renamer;
in
  walk
