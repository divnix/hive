let
  inherit (cell) homeSuites;

  name = "David Arnold";
  # email = "dgx.arnold@gmail.com";
  # gitSigningKey = "AB15A6AF1101390D";
  email = "david.arnold@iohk.io";
  gitSigningKey = "0318D822BAC965CC";

  programs = {
    git = {
      userName = name;
      userEmail = email;
      signing = {
        key = gitSigningKey;
        signByDefault = true;
      };
    };
  };
  bee = {
    system = "x86_64-linux";
    inherit (inputs) home;
    pkgs = inputs.nixos.legacyPackages;
  };
  home = rec {
    homeDirectory = "/home/${username}";
    stateVersion = "22.05";
    username = "blaggacao";
  };
  manual = {
    manpages.enable = false; # causes error
    html.enable = false; # saves space
    json.enable = false; # don't know what to do with this
  };
in {
  workstation = {
    inherit programs bee home manual;
    imports = with homeSuites;
      []
      ++ gui
      ++ shell
      ++ nix;
  };
  server = {
    inherit programs bee home manual;
    imports = with homeSuites;
      []
      ++ shell
      ++ nix;
  };
}
