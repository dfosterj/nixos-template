{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      # Hide welcome message & ensure we are reporting fish as shell
      set fish_greeting
      set -x VIRTUAL_ENV_DISABLE_PROMPT "1"
      set -xU MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set -xU MANROFFOPT "-c"
      set -x SHELL "fish"
      # set -x LC_ALL "C"

      # Set settings for https://github.com/franciscolourenco/done
      set -U __done_min_cmd_duration 10000
      set -U __done_notification_urgency_level low

      # Apply .profile: use this to put fish compatible .profile stuff in
      if test -f ~/.fish_profile
        source ~/.fish_profile
      end

      # Set a variable for the current user
      set user (whoami)

      # Append directories to the $PATH without checking existence
      set -gx PATH $PATH /home/$user/.local/bin
      set -gx PATH $PATH /usr/local/bin
      set -gx PATH $PATH /home/$user/.dotfiles/bin
      set -gx PATH $PATH /nix/var/nix/profiles/default/bin
      set -gx PATH $PATH /home/$user/.local/state/nix/profiles/profile/bin

      # Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
      function __history_previous_command
        switch (commandline -t)
        case "!"
          commandline -t $history[1]; commandline -f repaint
        case "*"
          commandline -i !
        end
      end

      function __history_previous_command_arguments
        switch (commandline -t)
        case "!"
          commandline -t ""
          commandline -f history-token-search-backward
        case "*"
          commandline -i '$'
        end
      end

      if [ "$fish_key_bindings" = fish_vi_key_bindings ];
        bind -Minsert ! __history_previous_command
        bind -Minsert '$' __history_previous_command_arguments
      else
        bind ! __history_previous_command
        bind '$' __history_previous_command_arguments
      end

      # Fish command history
      function history
          builtin history --show-time='%F %T '
      end

      function backup --argument filename
          cp $filename $filename.bak
      end

      # Replace ls with eza
      alias la 'eza -a --color=always --group-directories-first --icons'
      alias ll 'eza -l --color=always --group-directories-first --icons'
      alias lt 'eza -aT --color=always --group-directories-first --icons'
      alias l. 'eza -ald --color=always --group-directories-first --icons .*'
      alias lart 'eza -al --color=always --time modified --sort time --icons'

      # Get the error messages from journalctl
      alias jctl 'journalctl -p 3 -xb'

      alias bi='blkid -o list -c /dev/null'

      # Nord Colors
      set -g fish_color_normal        '#D8DEE9'
      set -g fish_color_command       '#D8DEE9'
      set -g fish_color_keyword       '#88C0D0'
      set -g fish_color_quote         '#8FBCBB'
      set -g fish_color_redirection   '#81A1C1'
      set -g fish_color_end           '#88C0D0'
      set -g fish_color_error         '#BF616A'
      set -g fish_color_param         '#EBCB8B'
      set -g fish_color_comment       '#4C566A'
      set -g fish_color_match         '#8FBCBB'
      set -g fish_color_search_match  '#88C0D0'
      set -g fish_color_operator      '#81A1C1'
      set -g fish_color_escape        '#8FBCBB'
      set -g fish_color_cwd           '#8FBCBB'
      set -g fish_color_cwd_root      '#8FBCBB'
      set -g fish_color_autosuggestion '#4C566A'
      set -g fish_color_selection     '#3B4252' --bold --underline
      set -g fish_color_user          '#88C0D0'
      set -g fish_color_host          '#5E81AC'
      set -g fish_color_pager_prefix  '#81A1C1'
      set -g fish_color_pager_progress '#4C566A'

      function history
          builtin history --show-time="%Y-%m-%d %H:%M:%S " | awk '{print NR "\t" $0}'
      end

      function fish_prompt
          set_color cyan
          echo -n ">>"
          set_color white
          echo -n ">  "
          set_color cyan
          echo -n "~  "
          set_color '#8FBCBB' --bold
          if test (pwd) = $HOME; echo -n '~ '; else; echo -n "$(basename (pwd)) "; end
          set_color "#8FBCBB"
          if git rev-parse --is-inside-work-tree > /dev/null 2>&1
              echo -n "["
              set_color "#EBCB8B"
              set branch_name (git branch --show-current)
              if test -z "$branch_name"
                  set commit_hash (git rev-parse --short HEAD)
                  set branch_name "detached HEAD: $commit_hash"
              end
              echo -n "$branch_name"
              set_color "#8FBCBB"
              echo -n "] "
              if not git diff --quiet
                  echo -n "⚡ "
              end
          end
          set -g fish_color_command normal
      end

      alias tc="cd $HOME/.config"
      alias tv="cd $HOME/.config/nvim"
      alias tw="cd $HOME/work"
      alias td="cd $HOME/.dotfiles"
      alias th="cd /etc/nixos/nix/home/"
      alias tn="cd /etc/nixos/nix"
      alias ns="sudo nixos-rebuild switch --flake /etc/nixos/nix#default --impure"
      alias nt="sudo nixos-rebuild test --flake /etc/nixos/nix#default --impure"

      set -Ux EDITOR vim
    '';
  };
}
