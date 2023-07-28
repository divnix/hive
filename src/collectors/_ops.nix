{
  inputs,
  nixpkgs,
  root,
}: let
  l = nixpkgs.lib // builtins;

  inherit
    (root)
    checks
    ;
in {
  modules = renamer: system: cell: [
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
    (l.mapAttrs (target: checks.modules))
  ];

  profiles = renamer: system: cell: [
    (l.mapAttrs (target: profile: ({
        config,
        lib,
        ...
      } @ profileInputs: {
        options.bee._profiles."${renamer cell target}".enable = lib.mkOption {
          type = lib.types.bool;
          default = lib.elem (renamer cell target) config.bee.profiles;
          description = "En-/Disable profile ${renamer cell target}";
        };
        config = lib.mkIf (config.bee._profiles."${renamer cell target}".enable) (profile profileInputs);
      })))
    (l.mapAttrs (target: checks.profiles))
  ];
}
