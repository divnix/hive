{nixpkgs}: let
  l = nixpkgs.lib // builtins;

  paisanoOutput = flakeRoot:
    l.intersectAttrs
    (l.genAttrs l.systems.doubles.all (_: null))
    flakeRoot;

  collectOps = [
    (l.collect (x: x ? name && x ? value))
    l.listToAttrs
  ];

  root = flakeRoot: cellBlock: ops: namer:
    l.pipe (
      l.mapAttrs (system:
        l.mapAttrs (cell: blocks: (
          l.pipe blocks (
            [(l.attrByPath [cellBlock] {})]
            ++ (ops system cell)
            ++ [(l.mapAttrs (target: l.nameValuePair (namer cell target)))]
          )
        )))
      (paisanoOutput flakeRoot)
    )
    collectOps;

  cell = flakeRoot: cell: cellBlock: ops: namer:
    l.pipe (
      l.mapAttrs (system: cells: let
        blocks = l.attrByPath [cell] [] cells;
      in
        l.pipe blocks (
          [(l.attrByPath [cellBlock] {})]
          ++ (ops system cell)
          ++ [(l.mapAttrs (target: l.nameValuePair (namer cell target)))]
        ))
      (paisanoOutput flakeRoot)
    )
    collectOps;
in {
  inherit root cell;
}
