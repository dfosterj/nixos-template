{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";


  # == Extra Boot ==
  boot = {
	# kernelPackages = pkgs.linuxPackages_latest;

    # == gaming ==
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
    # connect xbox controller
  	kernelParams = [
	    "nvidia-drm.modeset=1"
	    "nvidia-drm.fbdev=1"
  	];
  };


  # == Virtualization ==
  virtualisation = {
    docker = {
      enableNvidia = true;
    };
  };

  hardware = {
	enableRedistributableFirmware = true;
	opengl.enable = true;
	steam-hardware.enable = true;
  	cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    nvidia-container-toolkit.enable = true;
    opengl.driSupport32Bit = true;
    xpadneo.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
   hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };



  # == Bluetooth ==
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; settings.General = {
      experimental = true; # show battery
      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };
  services.blueman.enable = true;
}
