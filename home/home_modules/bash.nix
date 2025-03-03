{  pkgs, ... }:

{
  programs.bash = {
    enable = true;

    # Enable bash completion
    enableCompletion = true;

    # Set history configuration
    historyControl = [ "ignoreboth" ]; # Equivalent to HISTCONTROL=ignoreboth
    historyFileSize = 2000;            # Equivalent to HISTFILESIZE=2000
    historySize = 1000;                # Equivalent to HISTSIZE=1000

    # Set shell options
    shellOptions = [
      "histappend"   # Append to history file
      "checkwinsize" # Update LINES and COLUMNS after each command
    ];

    # Add aliases
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      alert = ''${pkgs.libnotify}/bin/notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '"'"'s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'"'"')"'';
    };

    # Custom initialization script
    initExtra = ''
      # If not running interactively, don't do anything
      case $- in
          *i*) ;;
            *) return;;
      esac

      # make less more friendly for non-text input files, see lesspipe(1)
      [ -x "${pkgs.less}/bin/lesspipe" ] && eval "$(SHELL=/bin/sh lesspipe)"

      # set a fancy prompt (non-color, unless we know we "want" color)
      case "$TERM" in
          xterm-color|*-256color) color_prompt=yes;;
      esac

      # enable color support of ls and also add handy aliases
      if [ -x "${pkgs.coreutils}/bin/dircolors" ]; then
          test -r ~/.dircolors && eval "$(${pkgs.coreutils}/bin/dircolors -b ~/.dircolors)" || eval "$(${pkgs.coreutils}/bin/dircolors -b)"
      fi

      if [ -f ~/.bash_aliases ]; then
          . ~/.bash_aliases
      fi

      # env var
      export LC_ALL="C"

      # paths
      export PATH="$PATH:$HOME/.rvm/bin"
      export PATH="$PATH:/opt/nvim-linux64/bin"
      export PATH="$PATH:$HOME/.dotfiles/bin"

      # starship theme
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
  };

  # Install required packages
  home.packages = with pkgs; [
    less          # for lesspipe
    coreutils     # for dircolors
    libnotify     # for notify-send
    starship      # for the starship prompt
  ];
}
