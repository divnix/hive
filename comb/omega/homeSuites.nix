let
  inherit (inputs.cells) blaggacao;

  inherit (cell) homeProfiles;
in {
  shell = with homeProfiles; [
    blaggacao.homeModules.alacritty
    alacritty
    bat
    broot
    direnv
    fzf
    gh
    git
    gpg
    jq
    mcfly
    packages
    starship
    zoxide
    zsh
  ];
}
