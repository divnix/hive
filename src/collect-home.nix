{
  inputs, # unused for now
  nixpkgs,
  cellBlock,
}: let
  l = nixpkgs.lib // builtins;

  inherit (import ./walk.nix {inherit nixpkgs cellBlock;}) walkPaisano;
  inherit (import ./bee-module.nix {inherit nixpkgs;}) beeModule checkBeeAnd tranformToHomeManagerConfig;

  # Error reporting
  showAssertions = let
    collectFailed = cfg:
      l.map (x: x.message) (l.filter (x: !x.assertion) cfg.assertions);
    showWarnings = res: let
      f = w: x: l.trace "warning: ${w}" x;
    in
      l.fold f res res.config.warnings;
  in
    evaled:
      showWarnings (
        let
          failed = collectFailed evaled.config;
          failedStr = l.concatStringsSep "\n" (map (x: "- ${x}") failed);
        in
          if failed == []
          then evaled
          else throw "\nFailed assertions:\n${failedStr}"
      );

  renamer = cell: target: "${cell}-${target}";
  walk = self:
    walkPaisano self (system: cell: [
      (l.mapAttrs (target: config: {
        _file = "Cell: ${cell} - Block: ${cellBlock} - Target: ${target}";
        imports = [config];
      }))
      (l.mapAttrs (target: checkBeeAnd tranformToHomeManagerConfig))
      (l.filterAttrs (_: config: config.bee.system == system))
      (l.mapAttrs (_: config: config.bee._evaled))
      (l.mapAttrs (_: hmCliSchema))
    ])
    renamer;

  hmCliSchema = evaled: let
    asserted = showAssertions evaled;
  in {
    # __schema = "v0";
    inherit (asserted) options config;
    inherit (asserted.config.home) activationPackage;
    newsDisplay = evaled.config.news.display;
    newsEntries = l.sort (a: b: a.time > b.time) (
      l.filter (a: a.condition) evaled.config.news.entries
    );
  };
in
  walk
