let
  inherit (inputs) nixos-generators disko;
  inherit (cell.pkgsFunc) ifwifi;
  inherit (config._module.args) pkgs;
in
  with pkgs.lib; {
    imports = [
      # compate with `nixos-generate` cli
      (nixos-generators + /format-module.nix)
      ({modulesPath, ...}: {
        imports = ["${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"];
        formatAttr = "isoImage";
        fileExtension = ".iso";
      })
    ];

    config = {
      nix = {
        package = pkgs.nix;
        # only part of ./modules/profiles/channels.nix since 22.11
        registry = {
          nixpkgs.flake.outPath = builtins.path {
            name = "source";
            path = pkgs.path;
          };
        };
        settings = {
          require-sigs = mkDefault false;
        };
        extraOptions = ''
          experimental-features = nix-command flakes recursive-nix
        '';
      };

      networking.domain = "local";

      # Provide networkmanager for easy wireless configuration.
      networking.networkmanager.enable = true;
      networking.wireless.enable = mkForce false;
      services.getty.helpLine =
        ''
          The "nixos" and "root" accounts have empty passwords.

          An ssh daemon is running. You then must set a password
          for either "root" or "nixos" with `passwd` or add an ssh key
          to /home/nixos/.ssh/authorized_keys be able to login.

          If you need a wireless connection, type
          `sudo systemctl start NetworkManager` and configure a
          network using `sudo ifwifi scan` & `sudo ifwifi connect`.

          To format the device(s), run `disko -m disko -f <flake#config>`
          on the origin flake with e.g.:
            `disko -m disko -f github:<org>/<repo>#<config>`
        ''
        + optionalString config.services.xserver.enable ''

          Type `sudo systemctl start display-manager' to
          start the graphical user interface.
        '';

      environment.systemPackages = [
        (pkgs.callPackage ifwifi {
          inherit (pkgs.darwin.apple_sdk.frameworks) Security;
        })
        (pkgs.callPackage (disko + /package.nix) {
          diskoVersion = let
            versionInfo = import (disko + /version.nix);
            version = versionInfo.version + (optionalString (!versionInfo.released) "-dirty");
          in
            version;
        })
      ];

      isoImage = {
        isoBaseName = mkForce "bootstrap";
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
