let
  inherit (inputs) nixpkgs;
in {
  shellPrograms.programs = import ./homeProfiles/shellPrograms.nix;
  guiPrograms.programs = import ./homeProfiles/guiPrograms.nix;
  shellPackages.home.packages = import ./homeProfiles/shellPackages.nix nixpkgs;
  guiPackages.home.packages = import ./homeProfiles/guiPackages.nix nixpkgs;
  nixProfile.nix = {
    package = nixpkgs.nix;
  };
}
