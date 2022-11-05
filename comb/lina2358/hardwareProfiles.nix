{
  lavinox = {
    imports = [
      inputs.disko.nixosModules.disko
      ./hardwareProfiles/lavinox/default.nix
      {disko.devices = import ./hardwareProfiles/lavinox/disko-config.nix;}
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      inputs.nixos-hardware.nixosModules.common-gpu-amd
    ];
  };
}
