{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs deploy-rs nixos;
  inherit (nixpkgs) lib;

  getFqdn = bee: res: let
    net = res.config.networking;
    fqdn =
      if net.domain != null
      then "${net.hostName}.${net.domain}"
      else "${net.hostName}.${bee}.hive";
  in
    fqdn;

  reverseFqdn = s: let
    partitionString = sep: s:
      with builtins; filter (v: isString v) (split "${sep}" s);
  in
    builtins.concatStringsSep "-"
    (lib.reverseList (partitionString "\\." s));
in {
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
   Synopsis: bearNixosConfiguration host: configuration:_
   
   Generate the deployable `nixosConfigurations` attribute set in the
   nixosConfigurations organelle.
   */
  bearNixosConfiguration = hostname: configuration: let
    builder = nixos.lib.nixosSystem;
    default = {
      networking.hostName = lib.mkForce hostname;
    };
    built = builder {
      inherit (nixpkgs) system; # initial system for nested specializations
      modules = [default configuration];
    };
  in
    if built.config.nixpkgs.system == nixpkgs.system
    then built
    else null;

  /*
   Synopsis: bearDeployConfigurationsFor _systems_
   
   Generate the `output.deploy.nodes` attribute expected by deploy-rs.
   
   Produces:
   {
     reverse-FQDN = {
       profiles.system = ...;
       hostname = FQDN;
     };
   }
   */
  bearDeployConfigurations = let
    systems = lib.intersectLists (builtins.attrNames inputs.cells) lib.systems.doubles.all;
    accumulate = builtins.foldl' inputs.nixpkgs.lib.attrsets.recursiveUpdate {};
    getNixosConfigurations = cells:
      lib.filterAttrs (n: v: v ? nixosConfigurations && v.nixosConfigurations != {}) cells;
    deploy = system:
      builtins.listToAttrs (lib.flatten (lib.mapAttrsToList (
          bee: organelles: let
            hasHomeConfigurations = organelles ? homeConfigurations && organelles.homeConfigurations != {};
            opHome = user: configuration: {
              inherit user;
              path = deploy-rs.lib.${system}.activate.home-manager configuration;
            };
            opNixOS = _: configuration: let
              fqdn = getFqdn bee configuration;
            in {
              name = reverseFqdn fqdn;
              value = {
                hostname = fqdn;
                profilesOrder =
                  ["system"]
                  ++ (
                    lib.optionals hasHomeConfigurations
                    (builtins.attrNames organelles.homeConfigurations)
                  );
                profiles =
                  {
                    system = {
                      user = "root";
                      # nixos configurations are already filtered by system
                      # see 'bearNixosConfigurations'
                      path = deploy-rs.lib.${system}.activate.nixos configuration;
                    };
                  }
                  // (
                    if hasHomeConfigurations
                    then builtins.mapAttrs opHome organelles.homeConfigurations
                    else {}
                  );
              };
            };
          in
            lib.mapAttrsToList opNixOS (lib.filterAttrs (_: v: v != null) organelles.nixosConfigurations)
        )
        (getNixosConfigurations inputs.cells.${system})));
  in
    accumulate (map (system: deploy system) systems);
  /*
   Synopsis: summonNixosConfigurationsFor _systems_
   
   Generate the `nixosConfigurations` attribute expected by nixos-generators.
   */
  summonNixosConfigurations = let
    systems = lib.intersectLists (builtins.attrNames inputs.cells) lib.systems.doubles.all;
    accumulate = builtins.foldl' inputs.nixpkgs.lib.attrsets.recursiveUpdate {};
    getNixosConfigurations = cells:
      lib.filterAttrs (n: v: v ? nixosConfigurations && v.nixosConfigurations != {}) cells;
    filter = system: (
      builtins.listToAttrs (lib.flatten (
        lib.mapAttrsToList
        (bee: organelles: let
          nonNullNixosConfigurations = lib.filterAttrs (_: v: v != null) organelles.nixosConfigurations;
        in
          lib.mapAttrsToList (
            _: configuration: let
              fqdn = getFqdn bee configuration;
            in {
              name = reverseFqdn fqdn;
              value = configuration;
            }
          )
          nonNullNixosConfigurations)
        (getNixosConfigurations inputs.cells.${system})
      ))
    );
  in
    accumulate (map (system: filter system) systems);
}
