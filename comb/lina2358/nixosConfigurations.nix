{
  lavinox = {
    bee.system = "x86_64-linux";
    bee.pkgs = import inputs.nixos {
      inherit (inputs.nixpkgs) system;
      config.allowUnfree = true;
      overlays = [];
    };
    imports = [
      cell.hardwareProfiles.lavinox
      ./nixosConfigurations/lavinox
    ];
  };
}
