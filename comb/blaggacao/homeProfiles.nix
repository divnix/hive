{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  bat.programs.bat.enable = true;
  broot.programs.broot.enable = true;
  direnv.programs.direnv.enable = true;
  fzf.programs.fzf.enable = true;
  gpg.programs.gpg.enable = true;
  jq.programs.jq.enable = true;
  mcfly.programs.mcfly.enable = true;
  starship.programs.starship.enable = true;
  zoxide.programs.zoxide.enable = true;
  gh.programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
  packages.home.packages = with nixpkgs; [
    bottom # more modern top / htop
    choose # between cut & awk - beautiful
    curlie # modern curl
    dogdns # modern dig
    duf # modern df
    du-dust # modern du
    exa # modern ls (not on LSD)
    fx # jq, but don't admit you somtimes like to use a mouse
    fd # modern find
    gitui # git tui, the nicer one
    gping # modern ping
    hyperfine # benchmark shell commands like a boss
    ijq # interactive jq wrapper, requires jq
    magic-wormhole # secure file sharing over cli
    navi # interactive cli cheat sheet with cheat.sh / tldr integration
    # NB: nixpkgs#tldr doesn't support the --makdown flag and wouldn't work with navi
    tealdeer # fast tldr in rust - an (optional) navi runtime dependency
    procs # modern ps
    sd # modern sed
    thefuck # if you mistyped: fuck
    tty-share # Secure terminal-session sharing
    watchexec # Executes commands in response to file modifications
    h # faster shell navigation of projects
    jd-diff-patch # semantic json differ
    arping
    pijul # modern darcs-inspired vcs
    eva # modern bc
    manix # explore nixos/hm options
    borgbackup # backup tool
    git-filter-repo # rewrite git history like a pro (and fast)
  ];
  alacritty.programs.alacritty = {
    enable = true;
    CSIuSupport = true;
    settings = {
      env.TERM = "xterm-256color";
      window.decorations = "full";
      font.size = 9.0;
      cursor.style = "Beam";

      # snazzy theme
      colors = {
        # Default colors
        primary = {
          background = "0x282a36";
          foreground = "0xeff0eb";
        };

        # Normal colors
        normal = {
          black = "0x282a36";
          red = "0xff5c57";
          green = "0x5af78e";
          yellow = "0xf3f99d";
          blue = "0x57c7ff";
          magenta = "0xff6ac1";
          cyan = "0x9aedfe";
          white = "0xf1f1f0";
        };

        # Bright colors
        bright = {
          black = "0x686868";
          red = "0xff5c57";
          green = "0x5af78e";
          yellow = "0xf3f99d";
          blue = "0x57c7ff";
          magenta = "0xff6ac1";
          cyan = "0x9aedfe";
          white = "0xf1f1f0";
        };
      };
    };
  };
  git.programs.git = {
    enable = true;
    delta.enable = true;
    lfs.enable = true;

    delta.options = {
      plus-style = "syntax #012800";
      minus-style = "syntax #340001";
      syntax-theme = "Monokai Extended";
      navigate = true;
    };

    extraConfig = {
      core.autocrlf = "input";
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autosquash = true;
      rerere.enabled = true;
    };
  };
  zsh.programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    history.share = true;
    dotDir = ".config/zsh";
    shellGlobalAliases = {
      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../...";
    };
    shellAliases = {
      d = "direnv";
      g = "git";
      jc = "journalctl";
      la = "exa -lah";
      l = "exa -lh";
      ls = "exa";
      md = "mkdir -p";
      n = "nix";
      rd = "rmdir";
      sc = "systemctl";
      "_" = "sudo ";
    };
    initExtra = ''
      export EDITOR=$(which vim)
      export GPG_TTY=$(tty)

      # Remove when intregrations are set up
      eval "$(thefuck --alias)"

      eval "$(h --setup ~/src)"

      ######################################### oh-my-zsh/lib/key-bindings.zsh #########################################
      # Start typing + [Up-Arrow] - fuzzy find history forward
      if [[ "''${terminfo[kcuu1]}" != "" ]]; then
        autoload -U up-line-or-beginning-search
        zle -N up-line-or-beginning-search
        bindkey "''${terminfo[kcuu1]}" up-line-or-beginning-search
      fi
      # Start typing + [Down-Arrow] - fuzzy find history backward
      if [[ "''${terminfo[kcud1]}" != "" ]]; then
        autoload -U down-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "''${terminfo[kcud1]}" down-line-or-beginning-search
      fi

      bindkey '^[[127;5u' backward-kill-word                  # [Ctrl-Backspace] - delete whole backward-word
      bindkey '^[[127;2u' backward-kill-word                  # [Shift-Backspace] - delete whole backward-word
      bindkey '^[[127;4u' backward-kill-line                  # [Shift-Alt-Backspace] - delete line up to cursor
      bindkey '^[[3;5~' kill-word                             # [Ctrl-Delete] - delete whole forward-word
      bindkey '^[[3;2~' kill-word                             # [Shift-Delete] - delete whole forward-word
      bindkey '^[[3;4~' kill-line                             # [Shift-Alt-Delete] - delete line from cursor
      bindkey '^[[Z' reverse-menu-complete                    # [Shift-Tab] - move through the completion menu backwards
      bindkey '^[[1;5C' forward-word                          # [Ctrl-RightArrow] - move forward one word
      bindkey '^[[1;5D' backward-word                         # [Ctrl-LeftArrow] - move backward one word
      ##################################################################################################################
    '';
  };
}
