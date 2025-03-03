{ config, pkgs, ... }:

{
  # Enable Vim configuration in Home Manager
  programs.vim = {
    enable = true;
     plugins = with pkgs.vimPlugins; [
        vim-plug
      ];
    # use default vimrc
    extraConfig = ''
	  " Check if ~/.vim/vimrc exists and source it
      if filereadable(expand("~/.vim/vimrc"))
        source ~/.vim/vimrc
      endif
    '';
  };
}

