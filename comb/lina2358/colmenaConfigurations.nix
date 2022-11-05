{
  lavinox = {
    bee.system = "x86_64-linux";
    bee.pkgs = import inputs.nixos {
      inherit (inputs.nixpkgs) system;
      config.allowUnfree = true;
      overlays = [];
    };
    deployment = {
      targetHost = "192.168.0.64";
    };
    imports = [cell.nixosConfigurations.lavinox];
  };
}
