{ config, lib, pkgs, ... }:

let
  hostVars = import ../../host-variables.nix;
  script = pkgs.writeShellScriptBin "custom-dotfile-check" ''
    #!/usr/bin/env bash

    USER="${hostVars.userName}"  # Set USER using the correct interpolation
    USER_DOTFILE_PATH="/home/''${USER}/.dotfiles/config"
    USER_DOTFILES=''$(ls ''${USER_DOTFILE_PATH})

    date
    echo "checking dotfile links for ''${USER}"

    for LINKED_CONFIG in ''${USER_DOTFILES}; do
      FULL_DOTFILE_PATH="''$(readlink -f /home/''${USER}/.config/''${LINKED_CONFIG})"
      if [[ ''${FULL_DOTFILE_PATH} == ''${USER_DOTFILE_PATH}/''${LINKED_CONFIG} ]]; then
        echo "OK...''${LINKED_CONFIG} is active"
      else
        echo "FAILED....missing ''${LINKED_CONFIG}. Attempting to link..."
        ln -sf ''${USER_DOTFILE_PATH}/''${LINKED_CONFIG} /home/''${USER}/.config/''${LINKED_CONFIG}
        echo 'Results of link action..'
        ls -lah /home/''${USER}/.config/''${LINKED_CONFIG}
      fi
    done
    echo "finished"
    echo ""
  '';
in
{
  systemd.services.custom-dotfile-check = {
    description = "Custom Dotfile Check Service";
    serviceConfig = {
      ExecStart = "${script}/bin/custom-dotfile-check";
      StandardOutput = "append:/var/log/${hostVars.userName}_sysd_userCustomDotfile.log";
      StandardError = "append:/var/log/${hostVars.userName}_sysd_userCustomDotfile.log";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Adding a timer for the systemd service
  systemd.timers."custom-dotfile-check" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      # OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "${hostVars.userName}-custom-dotfile.service";
    };
  };

  services.logrotate.settings."/var/log/${hostVars.userName}_sysd_userCustomDotfile.log" = {
    size = "500M";
    daily = true;
    compress = true;
    missingok = true;
    notifempty = true;
    dateext = true;
    rotate = 3;
    maxage = 1;
  };
}

