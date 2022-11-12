{
  lavinox = {pkgs, ...}: {
    bee.system = "x86_64-linux";
    bee.pkgs = import inputs.nixos {
      inherit (inputs.nixpkgs) system;
      config.allowUnfree = true;
      overlays = [];
    };
    imports = [
      cell.hardwareProfiles.lavinox
    ];

    # swapDevices = [
    #   {
    #     device = "/.swapfile";
    #     size = 8192; # ~8GB - will be autocreated
    #   }
    # ];
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    nix.settings = {
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      accept-flake-config = true;
    };

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Set your time zone.
    time.timeZone = "America/Bogota";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.wlp2s0.useDHCP = true;
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online = {
      enable = false;
      serviceConfig.TimeoutSec = 15;
      wantedBy = ["network-online.target"];
    };

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    # };

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      # Configure keymap in X11
      layout = "es";
      xkbOptions = "";
    };

    services.sshd.enable = true;
    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound.
    sound.enable = true;
    sound.mediaKeys.enable = true;
    hardware.pulseaudio.enable = true;
    # Enable scanning
    hardware.sane.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
      users.lar = {
        shell = pkgs.zsh;
        isNormalUser = true;
        initialPassword = "password123";
        extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      };
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      xclip
      tty-share
      alacritty
      element-desktop
      firefox
      chromium
      enpass
      # Office
      libreoffice
      onlyoffice-bin
      beancount
      fava
      direnv
      # Git & Tools
      git
      gh
      gitoxide
      ghq
      # Nix
      # nil # nix language server
      rnix-lsp # nix language server
      alejandra # nix formatter
      # Python
      (python3Full.withPackages (p:
        with p; [
          numpy
          pandas
          ptpython
          requests
          scipy
        ]))
      poetry # python project files
      black # python formatter
      (vscode-with-extensions.override {
        vscode = vscodium;
        vscodeExtensions = with vscode-extensions;
          []
          ++
          # When the extension is already available in the default extensions set.
          [
            yzhang.markdown-all-in-one
            editorconfig.editorconfig
            ms-python.python
            ms-python.vscode-pylance
            ms-pyright.pyright
            jnoortheen.nix-ide # TODO: how to configure
            timonwong.shellcheck
            marp-team.marp-vscode
            kubukoz.nickel-syntax
            ms-vscode-remote.remote-ssh
          ]
          # Concise version from the vscode market place when not available in the default set.
          ++ vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "beancount";
              publisher = "Lencerf";
              version = "0.9.1";
              sha256 = "sha256-88hSGTcjFx0n+tncGSoCgprNNnMihYZ6mSJc267thwE=";
            }
            {
              name = "gitlab-workflow";
              publisher = "GitLab";
              version = "3.56.0";
              sha256 = "sha256-jWNX/S+cCgQmjRKCN9osffBlJJhrKa65yhTt1z5+8VQ=";
            }
          ];
      })
    ];
    environment.sessionVariables = {
      PYTHONSTARTUP = let
        startup =
          pkgs.writers.writePython3 "ptpython.py"
          {
            libraries = with pkgs.python3Packages; [ptpython];
          } ''
            from __future__ import unicode_literals
            from pygments.token import Token
            from ptpython.layout import CompletionVisualisation
            import sys
            ${builtins.readFile ./ptconfig.py}
            try:
                from ptpython.repl import embed
            except ImportError:
                print("ptpython is not available: falling back to standard prompt")
            else:
                sys.exit(embed(globals(), locals(), configure=configure))
          '';
      in "${startup}";
    };

    # Programs configuration
    programs.starship.enable = true;
    programs.nix-ld.enable = true; # quality of life for downloaded programs
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      autosuggestions.async = true;
      syntaxHighlighting.enable = true;
      shellInit = ''
        eval "$(direnv hook zsh)"
      '';
    };
    programs.git = {
      enable = true;
      config = {
        user.name = "Lina Avendaño";
        user.email = "lina8823@gmail.com";
        init.defaultBranch = "main";
        core.autocrlf = "input";
        pull.rebase = true;
        rebase.autosquash = true;
        rerere.enable = true;
      };
    };
    programs.ssh = {
      extraConfig = ''
        Host github.com
          User git
          Hostname github.com
          IdentityFile ~/.ssh/lar
        Host gitlab.com
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/lar
      '';
    };
    programs.chromium = {
      enable = true;
      extensions = [
        # UID of extension
        "kmcfomidfpdkfieipokbalgegidffkal" # EnPass
        "bpconcjcammlapcogcnnelfmaeghhagj" # Nimbus
      ];
    };

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.05"; # Did you read the comment?
  };
}
