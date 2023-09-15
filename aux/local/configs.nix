let
  inherit (inputs) nixpkgs;
  inherit (inputs.std.data) configs;
  inherit (inputs.std.lib.dev) mkNixago;
in {
  treefmt = (mkNixago configs.treefmt) {};
  editorconfig = (mkNixago configs.editorconfig) {};
  conform = (mkNixago configs.conform) {};
  lefthook = (mkNixago configs.lefthook) {};

  cog = (mkNixago configs.cog) {
    data.changelog = {
      remote = "github.com";
      repository = "hive";
      owner = "divnix";
    };
  };

  githubsettings = (mkNixago configs.githubsettings) {
    data = {
      repository = {
        name = "hive";
        description = "The secretly open NixOS-Society";
        topics = "nix, nixos";
        default_branch = "main";
        allow_squash_merge = true;
        allow_merge_commit = false;
        allow_rebase_merge = true;
        delete_branch_on_merge = true;
      };
      milestones = [
        {
          title = "Block Type Actions";
          description = ":dart:";
          state = "open";
        }
      ];
    };
  };
}
