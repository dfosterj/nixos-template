{ config, pkgs, ... }:

let
  # Define a custom picom package
  picomPkg = pkgs.picom-pijulius.overrideAttrs (oldAttrs: rec {
    src = pkgs.fetchFromGitHub {
      # owner = "pijulius";
      # repo = "picom";
      # rev = "48022df5d237170091a6912db4309026e23b162b";
      # hash = "sha256-cy8+xT0rOgR/wepqDXiZc6zk0VDC+elfLmUPHIxtOzU=";
      # owner = "kiosion";
      # repo = "picom";
      # rev = "b0bb8015b90d2dd1e731731dbd3d1c735054b17a";
      # sha256 = "sha256-FTTjH8RWJ4qkFzZ2+09iUpzs4Zw3WQLoQr44RRGZmzg=";
      owner = "jonaburg";
      repo = "picom";
      rev = "65ad706ab8e1d1a8f302624039431950f6d4fb89";
      hash = "sha256-UKqMHUP6X3exG7obhuRPgXWPmwBeaGaqNYNtcBcimNQ=";
    };

    # Add necessary dependencies as build inputs
    nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [
      pkgs.cmake
      pkgs.asciidoc
      pkgs.pkg-config
      pkgs.meson
      pkgs.ninja
      pkgs.git
    ];

    buildInputs = oldAttrs.buildInputs or [] ++ [
      pkgs.pcre
      pkgs.cmake
      pkgs.libev
      pkgs.libconfig
      pkgs.libdbusmenu
      pkgs.libxdg_basedir
      pkgs.xorg.libX11
      pkgs.xorg.libXcomposite
      pkgs.xorg.libXdamage
      pkgs.xorg.libXext
      pkgs.xorg.libXfixes
      pkgs.xorg.libXinerama
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.fontconfig
	  pkgs.xorg.libxcb
      pkgs.gcc
      pkgs.gnumake
    ];
  });
in
{
  # Add the custom picom package to system packages
  environment.systemPackages = with pkgs; [
    picomPkg
  ];
}
