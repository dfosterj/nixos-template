{ config, pkgs, lib, ...}:
let
  hostVars = import ../../host-variables.nix;
in

{
  home.stateVersion = "24.11";
  home.username = "${hostVars.userName}";
  home.homeDirectory = "/home/${hostVars.userName}";

  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.allowUnfree = true;

  imports = [
	./home_modules
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  # Set Vim as the default editor and other session vars
  home.sessionVariables = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_UNFREE = 1;
    GEM_HOME = "${config.home.homeDirectory}/.rubygems";
    PATH = "${pkgs.ruby}/bin:${config.home.homeDirectory}/.rubygems/bin:$PATH";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  programs.git = {
    enable = true;
    userName = "${hostVars.userGitName}";
    userEmail = "${hostVars.userGitEmail}";
  };

  home.file.".gemrc".text = ''
    gem: --no-document
    install: --user-install
    gemhome: ${config.home.homeDirectory}/.rubygems
  '';

  # home.activation.customBashHere = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   echo "bash actions for custom scripts heere"
  # '';
}
