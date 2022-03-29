{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs deploy-rs nixos home;
  inherit (nixpkgs) lib;

  getFqdn = bee: res: let
    net = res.config.networking;
    fqdn =
      if net.domain != null
      then "${net.hostName}.${net.domain}"
      else "${net.hostName}.${bee}.hive";
  in
    fqdn;

  reverseFqdn = s:
    builtins.concatenateStringsSep "."
    (lib.reverseList (lib.partitionString "\\." s));
in {
  /*
   Synopsis: bearHomeConfigurations _attrs<username: configuration>_
   
   Generate the deployable `homeConfigurations` attribute set in the
   homeConfigurations organelle.
   */
  bearHomeConfigurations = {nixpkgs}: users: let
    op = username: configuration: let
      homeDirectoryPrefix =
        if nixpkgs.stdenv.hostPlatform.isDarwin
        then "/Users"
        else "/home";
      homeDirectory = "${homeDirectoryPrefix}/${username}";
      builder = home.lib.homeManagerConfiguration;
      default = (
        if nixpkgs.stdenv.hostPlatform.isLinux
        then {targets.genericLinux.enable = true;}
        else {}
      );
    in
      builder {
        inherit username homeDirectory;
        inherit (nixpkgs) system;
        pkgs = nixpkgs;
        configuration = default // {imports = [configuration];};
      };
  in
    builtins.mapAttrs op users;

  /*
   Synopsis: bearNixosConfigurations _attrs<host: configuration>_
   
   Generate the deployable `nixosConfigurations` attribute set in the
   nixosConfigurations organelle.
   */
  bearNixosConfigurations = hosts: let
    filteredHosts =
      lib.attrsets.filterAttrs
      (_: c: c.config.nixpkgs.system == nixpkgs.system)
      hosts;
    op = hostname: configuration: let
      builder = nixos.lib.nixosSystem;
      default = {networking.hostName = lib.mkForce hostname;};
    in
      builder {
        inherit (nixpkgs) system; # initial system for nested specializations
        modules = default // {imports = [configuration];};
      };
  in
    builtins.mapAttrs op filteredHosts;

  /*
   Synopsis: bearDeployConfiguration _self_
   
   Generate the `output.nodes` attribute expected by deploy-rs.
   
   Produces:
   {
     deploy.nodes.reverse-FQDN = {
       profiles.system = ...;
       hostname = FQDN;
     };
   }
   */
  # system.blaggacao.nixosConfigurations.hostname
  # system.blaggacao.homeConfigurations.username
  bearDeployConfiguration =
    # outputs.system
    builtins.mapAttrs (
      system:
      # outputs.system.cell
        builtins.mapAttrs (
          bee: organelles: let
            hasNixosConfigurations = organelles ? nixosConfigurations && organelles.nixosConfigurations != {};
            hasHomeConfigurations = organelles ? homeConfigurations && organelles.homeConfigurations != {};
            opHome = user: configuration: {
              inherit user;
              path = deploy-rs.lib.${system}.activate.home-manager configuration;
            };
            opNixOS = h: configuration: let
              fqdn = getFqdn bee c;
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
            if hasNixosConfigurations
            then lib.mapAttrs' opNixOS organelles.nixosConfigurations
            else {}
        )
    );
}
