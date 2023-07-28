{
  inputs,
  nixpkgs,
  root,
}: renamer: let
  cellBlock = "darwinProfiles";

  l = nixpkgs.lib // builtins;

  inherit (root) walkPaisano checks;

  walk = self:
    walkPaisano self cellBlock (system: cell: [
      (l.mapAttrs (target: profile: ({
          config,
          lib,
          ...
        } @ profileInputs: let
          evaled = profile profileInputs;
        in {
          options.bee._profiles."${renamer cell target}".enable = lib.mkOption {
            type = lib.types.bool;
            default = lib.elem (renamer cell target) config.bee.profiles;
            description = "En-/Disable profile ${renamer cell target}";
          };
          config = lib.mkIf (config.bee._profiles."${renamer cell target}".enable) evaled;
        })))
    ])
    renamer;
in
  walk
