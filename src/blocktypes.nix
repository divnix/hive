{nixpkgs}: let
  sharedActions = import ./actions.nix {inherit nixpkgs;};
  mkCommand = import ./mkCommand.nix {inherit nixpkgs;};
in {
  colmenaConfigurations = import ./blocktypes/colmenaConfigurations.nix {inherit nixpkgs mkCommand;};
  darwinConfigurations = import ./blocktypes/darwinConfigurations.nix {inherit nixpkgs mkCommand;};
  diskoConfigurations = import ./blocktypes/diskoConfigurations.nix {inherit nixpkgs mkCommand;};
  homeConfigurations = import ./blocktypes/homeConfigurations.nix {inherit nixpkgs mkCommand;};
  nixosConfigurations = import ./blocktypes/nixosConfigurations.nix {inherit nixpkgs mkCommand;};
}
