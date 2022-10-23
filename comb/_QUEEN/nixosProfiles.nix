{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs nixos-generators;
  l = nixpkgs.lib // builtins;
in {
  bootstrap = {
    config,
    options,
    ...
  }: {
    imports = [
      nixos-generators.nixosModules.install-iso
    ];

    nix = {
      package = nixpkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes recursive-nix
      '';
    };

    networking.domain = "local";

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
