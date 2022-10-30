let
  inherit (cell) homeSuites homeProfiles;

  name = "Omega Dilebo";
  email = "omega.meseret@iohk.io";
  gitSigningKey = "FFFFFFFFFFFFFFFF";
in {
  omega = {
    bee = {
      system = "x86_64-linux";
      inherit (inputs) home;
      pkgs = inputs.nixos.legacyPackages;
    };
    imports = with homeSuites; with homeProfiles; shell;
    programs.git = {
      userName = name;
      userEmail = email;
      # signing = {
      #  key = gitSigningKey;
      #  signByDefault = true;
      # };
    };
  };
}
