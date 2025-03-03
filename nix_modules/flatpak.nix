{ config, pkgs, inputs, lib, ... }:

{

  # Enable Flatpak in the system and add the Flathub repository
  services.flatpak.enable = true;

  # Activation script to add Flathub and install Chrome and Brave
  system.activationScripts.installFlatpakApps = lib.mkAfter ''
    # Path to the Flatpak binary
    FLATPAK=${pkgs.flatpak}/bin/flatpak

	########################################
	# Flatpak Repo
	########################################
    # Add the Flathub repository if it does not already exist
    if ! $FLATPAK remote-list | grep -q flathub; then
      $FLATPAK remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi


	########################################
	# Flatpak Apps
	########################################
    if ! $FLATPAK list | grep -q com.brave.Browser; then
      $FLATPAK install -y flathub com.brave.Browser
    fi

    if ! $FLATPAK list | grep -q org.chromium.Chromium; then
      $FLATPAK install -y flathub org.chromium.Chromium
    fi

    if ! $FLATPAK list | grep -q org.mozilla.firefox; then
      $FLATPAK install -y flathub org.mozilla.firefox
    fi

    if ! $FLATPAK list | grep -q com.mastermindzh.tidal-hifi; then
      $FLATPAK install -y flathub com.mastermindzh.tidal-hifi
    fi

	# == Work Apps ==
    if ! $FLATPAK list | grep -q us.zoom.Zoom; then
      $FLATPAK install -y flathub us.zoom.Zoom
    fi

	########################################
	# Flatpak ColorScheme
	########################################
    if ! $FLATPAK list | grep -q org.gtk.Gtk3theme.Matcha-dark-sea; then
      $FLATPAK install -y flathub org.gtk.Gtk3theme.Matcha-dark-sea
    fi
	$FLATPAK override --user --env=GTK_THEME=Matcha-dark-sea
  '';
}
