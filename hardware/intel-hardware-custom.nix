{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  #  == Boot ==
	# If you get an error like "your graphics device XXXX is not properly supported by i915 in this kernel version.
	# force driver probe by i915.force_probe=7d45 module parameter
	# or CONFIG_DRM_I915_FORCE_PROBE=7d45 configuration option.
    #boot.kernelParams = [ "i915.force_probe=XXXX" ];
	boot.kernelPackages = pkgs.linuxPackages_latest;

  #  == Hardware Custom  ==

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
		 # vpl-gpu-rt         # for quick sync video (obs studio ffmpeg)
		 # onevpl-intel-gpu   # for newer GPUs on NixOS <= 24.05
		 # intel-media-sdk    # for older GPUs
		 # vaapiIntel         # 6th Gen or Newer Specific Example
		 # intel-media-driver # 6th Gen or Newer Specific Example
      ];
    };
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
