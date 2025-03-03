{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
  };

  home.file.".config/eza/theme.yml".text =
    builtins.readFile ../dotfiles/eza/themes/frosty.yml;
}
