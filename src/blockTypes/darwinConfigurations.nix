{
  nixpkgs,
  root,
}: let
  inherit
    (root)
    mkCommand
    ;

  l = nixpkgs.lib // builtins;
  /*
  Use the darwinConfigurations Blocktype for
  final definitions of your Darwin hosts.
  */
  darwinConfigurations = {
    name = "darwinConfigurations";
    type = "darwinConfigurations";
    actions = {
      currentSystem,
      fragment,
      fragmentRelPath,
      target,
      inputs,
    }: let
      getString = o: (l.elemAt (l.splitString ["/"] fragmentRelPath) o);
      host = (getString 0) + "-" + (getString 2);
      dc = getString 1;
      bin = ''
        bin=$(nix build .#${dc}.${host}.system --no-link --print-out-paths)/sw/bin
        export PATH=$bin:$PATH
      '';
    in [
      (mkCommand currentSystem {
        name = "switch";
        description = "switch the configuration";
        command =
          bin
          + ''
            darwin-rebuild switch --flake .#${host}
          '';
      })
      (mkCommand currentSystem {
        name = "build";
        description = "build the configuration";
        command =
          bin
          + ''
            darwin-rebuild build --flake .#${host}
          '';
      })
      (mkCommand currentSystem {
        name = "exec";
        description = "exec the command with the configuration";
        command =
          bin
          + ''
            darwin-rebuild "$@" --flake .#${host}
          '';
      })
    ];
  };
in
  darwinConfigurations
