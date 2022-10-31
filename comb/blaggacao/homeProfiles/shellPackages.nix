nixpkgs:
with nixpkgs; [
  choose # between cut & awk - beautiful
  curlie # modern curl
  dogdns # modern dig
  duf # modern df
  du-dust # modern du
  exa # modern ls (not on LSD)
  fx # jq, but don't admit you somtimes like to use a mouse
  fd # modern find
  gping # modern ping
  hyperfine # benchmark shell commands like a boss
  ijq # interactive jq wrapper, requires jq
  magic-wormhole # secure file sharing over cli
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
]
