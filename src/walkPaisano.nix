{nixpkgs}: let
  l = nixpkgs.lib // builtins;

  walkPaisano = self: cellBlock: ops: namer:
    l.pipe (
      l.mapAttrs (system:
        l.mapAttrs (cell: blocks: (
          l.pipe blocks (
            [(l.attrByPath [cellBlock] {})]
            ++ (ops system cell)
            ++ [(l.mapAttrs (target: l.nameValuePair (namer cell target)))]
          )
        )))
      (l.intersectAttrs (l.genAttrs l.systems.doubles.all (_: null)) self)
    ) [
      (l.collect (x: x ? name && x ? value))
      l.listToAttrs
    ];
in
  walkPaisano
