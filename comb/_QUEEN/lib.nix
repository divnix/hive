{
  inputs,
  cell,
}: {
  colmenaHive = cellBlock: self: let
    makeHoneyFrom = import ./lib/make-honey.nix {
      inherit inputs cellBlock;
    };
  in
    makeHoneyFrom self;

  nixosConfigurations = cellBlock: self: let
    makeMeadFrom = import ./lib/make-mead.nix {
      inherit inputs cellBlock;
    };
  in
    makeMeadFrom self;
}
