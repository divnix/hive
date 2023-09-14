let
  inherit (inputs) nixpkgs nixos-generators nixos-anywhere;

  withCategory = category: attrset: attrset // {inherit category;};
in {
  commands = [
    (withCategory "bootstrap" {package = nixpkgs.writedisk;})
    (withCategory "bootstrap" {package = nixos-generators.packages.nixos-generate;})
    (withCategory "bootstrap" {package = nixpkgs.callPackage (nixos-anywhere + /src) {};})
  ];
}
