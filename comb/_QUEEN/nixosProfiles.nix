let
  inherit (inputs) nixpkgs nixos-generators;
  l = nixpkgs.lib // builtins;
in {
  bootstrap = {
    config,
    options,
    pkgs,
    ...
  }: {
    imports = [
      nixos-generators.nixosModules.install-iso
    ];

    nix = {
      # only part of ./modules/profiles/channels.nix since 22.11
      registry.nixpkgs.flake.outPath = builtins.path {
        name = "source";
        path = pkgs.path;
      };
      package = nixpkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes recursive-nix
      '';
    };

    networking.domain = "local";

    # Provide networkmanager for easy wireless configuration.
    networking.networkmanager.enable = true;
    networking.wireless.enable = l.mkForce false;
    services.getty.helpLine =
      ''
        The "nixos" and "root" accounts have empty passwords.

        An ssh daemon is running. You then must set a password
        for either "root" or "nixos" with `passwd` or add an ssh key
        to /home/nixos/.ssh/authorized_keys be able to login.

        If you need a wireless connection, type
        ``sudo systemctl start NetworkManager` and configure a
        network using `sudo ifwifi scan` & `sudo ifwifi connect`.
        See the NixOS manual for details.
      ''
      + l.optionalString config.services.xserver.enable ''

        Type `sudo systemctl start display-manager' to
        start the graphical user interface.
      '';
    environment.systemPackages = [
      (pkgs.callPackage ./nixosProfiles/ifwifi {
        inherit (pkgs.darwin.apple_sdk.frameworks) Security;
      })
    ];

    isoImage = {
      isoBaseName = "bootstrap-hive-from-queen";
      contents = [
        {
          source = inputs.self;
          target = "/hive/";
        }
      ];
    };

    systemd.network = {
      # https://www.freedesktop.org/software/systemd/man/systemd.network.html
      networks."boostrap-link-local" = {
        matchConfig = {
          Name = "en* wl* ww*";
        };
        networkConfig = {
          Description = "Link-local host bootstrap network";
          MulticastDNS = true;
          LinkLocalAddressing = "ipv6";
          DHCP = "yes";
        };
        address = [
          # fall back well-known link-local for situations where MulticastDNS is not available
          "fe80::47" # 47: n=14 i=9 x=24; n+i+x
        ];
        extraConfig = ''
          # Unique, yet stable. Based off the MAC address.
          IPv6LinkLocalAddressGenerationMode = "eui64"
        '';
      };
    };
  };
}
