{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs deploy-rs nixos;
  inherit (nixpkgs) lib;
in {
  lay = npkgs: host: configuration: {
    meta.nodeNixpkgs.${host} = npkgs;
    ${host} = configuration;
  };

  /*
   Synopsis: bearHomeConfiguration username: configuration:
   
   Generate the deployable `homeConfigurations` attribute set in the
   homeConfigurations organelle.
   */
  bearHomeConfiguration = home: username: configuration': let
    homeDirectoryPrefix =
      if nixpkgs.stdenv.hostPlatform.isDarwin
      then "/Users"
      else "/home";
    homeDirectory = "${homeDirectoryPrefix}/${username}";
    builder = import "${home}/modules/default.nix";
    configuration = {
      imports = [
        configuration'
        (
          if nixpkgs.stdenv.hostPlatform.isLinux
          then {targets.genericLinux.enable = true;}
          else {}
        )
        ({pkgs, ...}: {
          # _module.args.pkgsPath = pkgs.path;
          home = {inherit homeDirectory username;};
          home.stateVersion = lib.mkDefault "21.11";
        })
      ];
    };
  in
    builder {
      inherit configuration;
      # default, override via nixpkgs.pkgs
      pkgs = nixpkgs;
    };
  /*
   Synopsis: summonNixosConfigurationsFor _systems_
   
   Generate the `nixosConfigurations` attribute expected by nixos-generators.
   */
  # summonNixosConfigurations = let
  #   systems = lib.intersectLists (builtins.attrNames inputs.cells) lib.systems.doubles.all;
  #   accumulate = builtins.foldl' inputs.nixpkgs.lib.attrsets.recursiveUpdate {};
  #   getNixosConfigurations = cells:
  #     lib.filterAttrs (n: v: v ? nixosConfigurations && v.nixosConfigurations != {}) cells;
  #   filter = system: (
  #     builtins.listToAttrs (lib.flatten (
  #       lib.mapAttrsToList
  #       (bee: organelles: let
  #         nonNullNixosConfigurations = lib.filterAttrs (_: v: v != null) organelles.nixosConfigurations;
  #       in
  #         lib.mapAttrsToList (
  #           _: configuration: let
  #             fqdn = getFqdn bee configuration;
  #           in {
  #             name = reverseFqdn fqdn;
  #             value = configuration;
  #           }
  #         )
  #         nonNullNixosConfigurations)
  #       (getNixosConfigurations inputs.cells.${system})
  #     ))
  #   );
  # in
  #   accumulate (map (system: filter system) systems);
}
