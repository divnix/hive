let
  inherit (inputs.cells) blaggacao;

  inherit (cell) homeProfiles homeModules;
in {
  shell = [
    homeModules.alacritty
    homeProfiles.shellPackages
    homeProfiles.shellPrograms
  ];
  gui = [
    homeProfiles.guiPackages
    homeProfiles.guiPrograms
  ];
  nix = [
    homeProfiles.nixProfile
  ];
}
