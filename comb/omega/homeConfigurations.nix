let
  inherit (inputs) nixos home;

  inherit (inputs.cells) _QUEEN;

  inherit (cell.homeSuites) shell;

  name = "Omega Dilebo";
  email = "omega.meseret@iohk.io";
  gitSigningKey = "FFFFFFFFFFFFFFFF";
in
  builtins.mapAttrs (_QUEEN.library.bearHomeConfiguration home) {
    omega = {
      imports = shell;
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
