let
  inherit (inputs) nixpkgs nixgl;
in {
  shellPrograms.programs = import ./homeProfiles/shellPrograms.nix;
  guiPrograms.programs = import ./homeProfiles/guiPrograms.nix;
  shellPackages.home.packages = import ./homeProfiles/shellPackages.nix nixpkgs;
  guiPackages.home.packages = import ./homeProfiles/guiPackages.nix nixpkgs;
  systemProfile = {
    home.packages = [
      nixpkgs.nix
      nixgl.packages.nixGLIntel
    ];
    nix = {
      package = nixpkgs.nix;
    };
  };
}
