# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:
let
  hostVars = import ../host-variables.nix;
in
{
  system.stateVersion = "24.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ########################################
  # Imports
  ########################################
  imports =
    [
	../hardware-configuration.nix
	inputs.home-manager.nixosModules.default
    (./. + "/hardware/${hostVars.workstationName}-hardware-custom.nix")
    ./nix_modules/pkgs.nix
    ./nix_modules/flatpak.nix
    ./nix_modules/picom.nix
	./nix_modules/unstable.nix
    # ./nix_modules/systemd_custom_dotfile.nix
    ];


  ########################################
  # Network
  ########################################
  networking.hostName = "${hostVars.workstationName}";
  # networking.wireless.enable = true; #configurated in common hardware files ./hardware/
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  services.xrdp.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
 
  ########################################
  # Locale
  ########################################
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ########################################
  # Desktop Env
  ########################################
  services.xserver = {
    enable = true;
    displayManager.autoLogin.enable = false;
    displayManager.autoLogin.user = "${hostVars.userName}";
    windowManager.bspwm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;
  services.libinput.enable = true;

  fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [
    fira-code-nerdfont
    jetbrains-mono
    iosevka
    font-awesome
    material-design-icons
    unifont
   ];

  fontconfig = {
    defaultFonts = {
      monospace = [ "Jetbrains Mono Nerd Font" ];
      serif = [ "Jetbrains Mono Nerd Font" ];
      sansSerif = [ "Jetbrains Mono Nerd Font" ];
      };
    };
  };

  programs.bash = {
    shellAliases = {
      nt = "sudo nixos-rebuild test --flake /etc/nixos/nix#default --impure";
      ns = "sudo nixos-rebuild switch --flake /etc/nixos/nix#default --impure";
    };
  };


  ########################################
  # Sound
  ########################################
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    #media-session.enable = true;
  };


  ########################################
  # User
  ########################################
  users.users.${hostVars.userName} = {
    isNormalUser = true;
    description = "${hostVars.userName}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = "${pkgs.fish}/bin/fish";
    home = "/home/${hostVars.userName}";
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    # users = { "${hostVars.userName}" = import (config.users.users.${hostVars.userName}.home + "/.config/home-manager/home.nix"); };
    users = { "${hostVars.userName}" = import (./. + "/home/home.nix"); };
  };
  security.sudo = {
    enable = true;
    extraConfig = ''
      ${hostVars.userName} ALL=(ALL) NOPASSWD:ALL
    '';
  };



  ########################################
  # Programs
  ########################################

  programs  = {
	hyprland.enable = true;
	fish.enable = true;
    ssh.askPassword = "lib.mkForce = false";
  };

  # == Slock ==
  # fix suid
  # this is simple lock screen for bspwm
  security.wrappers.slock = {
    source = "${pkgs.slock}/bin/slock";
    owner = "root";
    group = "root";
    setuid = true;
  };


  ########################################
  # Virtualization
  ########################################
  virtualisation = {
    docker = {
      enable = true;
      # enableNvidia = true; #configured in common hardware files ./hardware/
    };
  };
}
