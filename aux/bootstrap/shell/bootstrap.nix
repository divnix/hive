let
  inherit (inputs) nixos-generators nixos-anywhere;
  inherit (config._module.args) pkgs;

  withCategory = category: attrset: attrset // {inherit category;};
in {
  commands = [
    (withCategory "bootstrap" {package = pkgs.writedisk;})
    (withCategory "bootstrap" {package = pkgs.callPackage (nixos-generators + /package.nix) {};})
    (withCategory "bootstrap" {package = pkgs.callPackage (nixos-anywhere + /src) {};})
  ];
}
