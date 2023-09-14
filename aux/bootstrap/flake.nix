{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixos-generators = {
    url = "github:nix-community/nixos-generators";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixos-anywhere = {
    url = "github:numtide/nixos-anywhere?ref=refs/pull/213/head";
    flake = false;
  };

  outputs = i: i;
}
