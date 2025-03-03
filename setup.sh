#!/usr/bin/env bash

echo "adding unstable channel...."
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --update

# create host-variable file
read -p "Enter the hostname: " workstationName
read -p "Enter the username: " userName
read -p "Enter the userGitName: " userGitName
read -p "Enter the userGitEmail: " userGitEmail

# Create /etc/nixos/host-variables.nix with the provided hostname
cat <<EOF | sudo tee /etc/nixos/host-variables.nix > /dev/null
{
  workstationName = "$workstationName";
  userName = "$userName";
  userGitName = "$userGitName";
  userGitEmail = "$userGitEmail";
}
EOF

echo "variables saved at /etc/nixos/host-variables.nix"
