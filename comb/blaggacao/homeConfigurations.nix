let
  inherit (inputs) nixos home;

  inherit (inputs.cells) _QUEEN;

  inherit (cell.homeSuites) shell;

  name = "David Arnold";
  # email = "dgx.arnold@gmail.com";
  # gitSigningKey = "AB15A6AF1101390D";
  email = "david.arnold@iohk.io";
  gitSigningKey = "0318D822BAC965CC";
in
  builtins.mapAttrs (_QUEEN.library.bearHomeConfiguration home) {
    blaggacao = {
      imports = shell;
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
