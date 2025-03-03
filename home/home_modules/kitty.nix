{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = "no";
      background_opacity = "0.5";
      font_family = "JetBrains Mono Nerd Font";
      font_size = "12.0";
      window_decorations = "none";
    };
    keybindings = {
      "kitty_mod+enter" = "launch --cwd=current --type=window";
      "cmd+enter" = "launch --cwd=current --type=window";
      "kitty_mod+t" = "launch --cwd=current --type=tab";
      "cmd+t" = "launch --cwd=current --type=tab";
      "ctrl+shift+down" = "next_window";
      "ctrl+shift+up" = "previous_window";
    };
    extraConfig = ''
      include ./themes/nord.conf
    '';
  };

  home.file.".config/kitty/themes/nord.conf".text =
    builtins.readFile ../dotfiles/kitty/themes/nord.conf;
}
