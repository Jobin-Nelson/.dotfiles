#!/usr/bin/bash
#  ____            _
# | __ )  __ _ ___| |__  _ __ ___
# |  _ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |____/ \__,_|___/_| |_|_|  \___|
#
#


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment variables
HISTCONTROL=ignoreboth
HISTTIMEFORMAT='[%Y/%m/%d %T] '
HISTSIZE=5000
HISTFILESIZE=5000
PROMPT_DIRTRIM=2

# Options
set -o vi
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob
shopt -s cdspell

# Prompt
PS1='\n[\[\033[01;32m\]\u@\[\033[35m\]\h\[\033[00m\]]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alFh --group-directories-first --color=auto'
alias grep='grep --color=auto'
alias less='less -i -R'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias eup='${EDITOR:-nvim} $HOME/playground/dev/illumina/daily_updates/$(date -d "$([[ $(date -d "+6 hours" +%u) -gt 5 ]] && echo "next Monday" || echo "+6 hours")" +%Y-%m-%d).txt'
alias bt="upower -i \$(upower -e | grep 'BAT') | grep -E \"state|to full|percentage\""
alias wl='nsxiv $HOME/Pictures/wallpapers'
alias twl='nsxiv $HOME/Pictures/wallpapers/$(date +%F)'
# alias rwl="feh --randomize --bg-scale \$HOME/Pictures/wallpapers/*"
alias rwl='gsettings set org.gnome.desktop.background picture-uri-dark file://$(find $HOME/Pictures/wallpapers -type f | shuf -n 1)'
# alias rwl='w=$(find $HOME/Pictures/wallpapers -type f | shuf -n 1) && hyprctl hyprpaper unload all && hyprctl hyprpaper preload "$w" && hyprctl hyprpaper wallpaper "eDP-1,$w" '
alias pomo='sleep 1h && notify-send "Focus Session Over" && paplay /usr/share/sounds/freedesktop/stereo/complete.oga &'
# alias emacs='emacsclient -nc -a ""'
# alias todo='${EDITOR:-nvim} -c ":cd $HOME/playground/projects/org_files" $HOME/playground/projects/org_files/refile.org +$'
# alias ftodo='file=$(rg --line-number --no-heading --with-filename "\*+ TODO" $HOME/playground/projects/org_files | fzf -d ":" --prompt "Find Todo: " --with-nth "3.." --layout=reverse --height=50% --ansi --border | sed -E "s/(.*):([0-9]+):.*/\1 +\2/") && [[ -n $file ]] && ${EDITOR:-nvim} -c ":cd $HOME/playground/projects/org_files" $file'
# alias note='${EDITOR:-nvim} -c ":cd $HOME/playground/projects/second_brain | set wrap linebreak" $HOME/playground/projects/second_brain/Notes/inbox.md +$'
# alias fnote='file=$(find $HOME/playground/projects/second_brain/ -type f -not -path "*.git*" -a -not -path "*/attachments/*" -a -not -path "*/.obsidian/*" -a -not -path "*/.stfolder/*" -a -not -path "*/.trash/*" | fzf --prompt "Find Note: " --layout=reverse --height=50% --ansi --border) && [[ -n $file ]] && ${EDITOR:-nvim} -c ":cd $HOME/playground/projects/second_brain | set wrap linebreak" $file'
# alias n='NVIM_APPNAME=my_nvim nvim'
alias fkill='for instanceId in $(flatpak ps --columns=instance | sed "1d"); do flatpak kill "${instanceId}"; done'
alias gcc='gcc -Wall -Wextra -Wpedantic -pedantic-errors -Wno-unused-variable -Wno-unused-parameter -g -fmax-errors=1 -Wfatal-errors -D_GLIBCXX_DEBUG -fsanitize=undefined -fsanitize=address'

# WSL
# alias chrome='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
# alias brave='/mnt/c/Program\ Files/BraveSoftware/Brave-Browser/Application/brave.exe'
# export SCREENDIR=$HOME/.screen
# service cron status &> /dev/null || sudo service cron start

# Nice to have
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Setting editor
export EDITOR='/usr/bin/nvim'
export VISUAL='/usr/bin/nvim'
export COLORTERM="truecolor"
# export MANPAGER='nvim +Man!'

# XDG
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Scripts
case ":${PATH}:" in
  *:"${HOME}/.local/bin":*) ;;
  *)
	  [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
	  ;;
esac

# Fzf completion
export FZF_DEFAULT_OPTS='--border --layout=reverse --height=40% --info=right --cycle'
eval "$(fzf --bash)"
[[ -s $HOME/.config/fzf/fzf-git.sh ]] && \. "${HOME}/.config/fzf/fzf-git.sh"

# Directory jumper
eval "$(zoxide init bash)"

# Pyenv [Python version manager]
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Cargo [Rust]
[[ -s $HOME/.cargo/env ]] && \. "$HOME/.cargo/env"

# Go
command -v go > /dev/null && export PATH="$(go env GOPATH)/bin:${PATH}"

# Starship prompt
eval "$(starship init bash)"

# Greeting
cat <<EOF
  .----------------.
  |  Hello Friend  |
  '----------------'
      ^      (\_/)
      '----- (O.o)
             (> <)
              " "
EOF
