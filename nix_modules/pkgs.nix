{ config, pkgs, inputs, lib, ... }:

{
  ########################################
  # Pkgs
  ########################################
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # == Core ==
    # brave
    # chromium
    # tidal-hifi
    alacritty
    bat
    bluetuith
    cava
    cliphist
    clipmenu
    clippy
    coreutils
    cpio
    eza
    fd
    fish
    flameshot
    flatpak
    fzf
    glibc
    jq
    killall
    kitty
    libglvnd
    lsd
    luckybackup
    neofetch
    nix-prefetch-git
    nix-search-cli
    ntfs3g
    p7zip
    procps
    protonvpn-gui
    psmisc
    pulsemixer
    qjackctl
    qpwgraph
    ranger
    ripgrep
    skim
    starship
    tor
    torsocks
    unzip
    wezterm
    wmctrl
    wget
    xclip
    zenity
    # == Dev ==
    cmake
    docker
    docker-compose
    gcc
    gh
    gh-dash
    git
    git-crypt
    glab
    gnumake
    go
    godot_4
    lazygit
    lua-language-server
    meson
    neovide
    nurl
    pavucontrol
    python3Full
    ruby_3_2
    sqlite
    stylua
    tflint
    tint2
    tmux
    vimPlugins.vim-plug
    vscodium
    yarn
    # == Hyprland ==
    nwg-bar
    nwg-drawer
    swww
    waybar
    swaylock
    # == Bspwm ==
    brightnessctl
    bspwm
    dmenu
    dunst
    escrotum
    feh
    networkmanager_dmenu
    # picom
    polybarFull
    rofi
    slock
    sxhkd
    wofi
    xautolock
    xorg.libxcb
  ];
}
