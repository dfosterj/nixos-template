# Nix Setup

This is a NixOS setup that tries to live all outside of whats installed and setup via NixOS installer.

## Setup
1.) Install Nixos from ISO.

2.) install git and vim temporarily
```bash
nix-env -iA nixos.vim
nix-env -iA nixos.git
```

3.) Make backup copy then edit configuration.nix file.

```
keep only boot.* conf and import lines (See layout example at below).
The reasoning is to keep unique hardware and boot
outside of this repos, since it can contain uniq or sensitive information.

Add the path to this nix directory to imports (see example below).
```

4.) Create or decide common hardware configuration to use,
```
a generic laptop,desktop,  and nvidia gaming desktop hardware confs can be found at ./hardware/
decide and remember the name, or create your own to be used in setup.sh
```

5.) Run setup script or manually create /etc/nixos/host-variables.nix using the common hardware conf (see example below)
```bash
bash ./setup.sh
```

6.) Build the and switch into flake
```bash
# remove temporariy pkgs
nix-env -e vim
nix-env -e git
sudo nixos-rebuild switch --flake /etc/nixos/${DIRNAME}#default --impure
```

enjoy and happy nix'n


## Information about this nix structure

This setup uses flakes and home manager using the userName variable from host-variables.nix
It has some app and dotfile ustomizations at home/home_modules.
It also includes some colorscheme variations at ./home/dotfiles/$APPNAME

System pkgs are located at ./nix_modules/pkgs.nix
User apps use flatpaks located at ./nix_modules/flatpak.nix.
Which also include colorscheme override

Home.nix has just some basic git information setup, ruby gem env setup.

#### == Nvidia Gaming ==
The hardare/nvidia-gaming.nix is a working example for gamepad and nvidia setup.

#### == Dotfiles, interim setup outside of Nix ==
Dotiles that are WIPS or have sensitive information live in another repo.
They are symlinked by the systemd service at ./nix_modules/systemd_custom_dotfile.nix.
This service will look for files and folders places at $HOME/.dotfiles/config
and will link them to default $HOME/.config/ to be live on system.

This systemd service is commented out by default.
Its a working method to develop your own nix while using it as a daily driver.


## Example files

### example /etc/nixos/host-variables.nix
```
{
  workstationName = "myworkstationName";
  userName = "myUserName";
  userGitName = "my git username";
  userGitEmail = "myGit@email.com";
}
```


### example /etc/nixos/configuration.nix
```
###########################################
# Danger!!!! Do not copy! Reference only!
just reference to show the conf lines to keep.
###########################################

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./custom/configuration-custom.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."".device = "";
  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."".keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."".keyFile = "/boot/crypto_keyfile.bin";

  ###########################################
  # Danger!!!! Do not copy! Reference only!
  just reference to show the conf lines to keep.
  ###########################################
}
