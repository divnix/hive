{nixpkgs}: let
  mkCommand = currentSystem: args:
    args
    // {
      command = (nixpkgs.legacyPackages.${currentSystem}.writeShellScript "${args.name}" args.command).overrideAttrs (self: {
        passthru =
          self.passthru
          or {}
          // nixpkgs.lib.optionalAttrs (args ? proviso) {
            proviso = builtins.toFile "${args.name}-proviso" args.proviso;
          }
          // nixpkgs.lib.optionalAttrs (args ? targetDrv) {
            inherit (args) targetDrv;
          };
      });
    };
in
  mkCommand
