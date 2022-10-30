let
  inherit (inputs) nixpkgs;
in {
  iog-patched-nix = {
    nix = {
      package = nixpkgs.nix;
      gc.automatic = true;
      gc.options = "--max-freed $((10 * 1024 * 1024))";
      optimise.automatic = true;
      autoOptimiseStore = true;
      extraOptions = ''
        experimental-features = nix-command flakes recursive-nix
      '';
      binaryCaches = ["https://hydra.iohk.io"];
      binaryCachePublicKeys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
    };
  };
}
