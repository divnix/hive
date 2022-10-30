let
  inherit (cell) homeSuites homeProfiles;

  name = "David Arnold";
  # email = "dgx.arnold@gmail.com";
  # gitSigningKey = "AB15A6AF1101390D";
  email = "david.arnold@iohk.io";
  gitSigningKey = "0318D822BAC965CC";
in {
  blaggacao = {
    bee = {
      system = "x86_64-linux";
      inherit (inputs) home;
      pkgs = inputs.nixos.legacyPackages;
    };
    home.homeDirectory = "/home/blaggacao";
    imports = with homeSuites; with homeProfiles; shell;
    programs.browserpass.enable = true;
    programs.git = {
      userName = name;
      userEmail = email;
      signing = {
        key = gitSigningKey;
        signByDefault = true;
      };
    };
  };
}
