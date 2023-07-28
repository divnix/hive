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
        imports = l.attrByPath ["imports"] [] evaled;
        options.bee.modules."${renamer cell target}" =
          {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "En-/Disable module ${renamer cell target}";
            };
          }
          // (l.attrByPath ["options"] {} evaled);
        config = lib.mkIf (config.bee.modules."${renamer cell target}".enable) (l.attrByPath ["config"] {} evaled);
      })))
    (l.mapAttrs (target: checks.modules))
  ];

  profiles = renamer: system: cell: [
    (l.mapAttrs (target: profile: ({
        config,
        lib,
        ...
      } @ moduleInputs: let
        evaled = profile (renamer cell) moduleInputs;
      in {
        imports = l.attrByPath ["imports"] [] evaled;
        options.bee._profiles."${renamer cell target}".enable = lib.mkOption {
          type = lib.types.bool;
          default = lib.elem (renamer cell target) config.bee.profiles;
          description = "En-/Disable profile ${renamer cell target}";
        };
        config =
          lib.mkIf
          (config.bee._profiles."${renamer cell target}".enable) (
            if l.hasAttr "config" evaled
            then evaled.config
            else evaled
          );
      })))
    (l.mapAttrs (target: checks.profiles))
  ];
}
