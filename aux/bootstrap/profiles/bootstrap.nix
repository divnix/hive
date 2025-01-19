let
  inherit (inputs) nixos-generators disko;
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

      services.getty.helpLine = ''
        To format drives and install a system in one go, you can use diko, e.g.:
          `disko-install --write-efi-boot-entries --flake <flake>#<config> --disk main /dev/...`
      '';

      environment.systemPackages = [
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
