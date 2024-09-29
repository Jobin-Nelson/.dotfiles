#!/usr/bin/bash
#  _               _              
# | |__   __ _ ___| |__  _ __ ___ 
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__ 
# |_.__/ \__,_|___/_| |_|_|  \___|
#


# If not running interactively, don't do anything
[[ $- == *i* ]] || return

# Environment variables
HISTCONTROL=ignoreboth
HISTTIMEFORMAT='[%Y/%m/%d %T] '
HISTSIZE=10000
HISTFILESIZE=10000
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

# Setting editor
export EDITOR='nvim'
export VISUAL='nvim'
export COLORTERM="truecolor"
# export MANPAGER='nvim +Man!'

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alFh --group-directories-first --color=auto'
alias grep='grep --color=auto'
alias less='less -i -R'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias eup='${EDITOR:-nvim} $HOME/playground/dev/illumina/daily_updates/$(date -d "$([[ $(date -d "+6 hours" +%u) -gt 5 ]] && echo "next Monday" || echo "+6 hours")" +%Y-%m-%d).md'
alias bt="upower -i \$(upower -e | grep 'BAT') | grep -E \"state|to full|percentage\""
alias wl='nsxiv $HOME/Pictures/wallpapers/**/*'
alias twl='nsxiv $HOME/Pictures/wallpapers/$(date +%F)'
alias rwl='w=$(find $HOME/Pictures/wallpapers -type f -name '"'"'*.png'"'"' -or -name '"'"'*.jpg'"'"' | shuf -n 1) && if [[ $XDG_CURRENT_DESKTOP = "GNOME" ]]; then gsettings set org.gnome.desktop.background picture-uri-dark "file://$w"; elif [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then reload.sh -p $w; elif [[ $XDG_CURRENT_DESKTOP = "KDE" ]]; then reload.sh -k "$w"; fi'
alias pomo='sleep 1h && notify-send "Focus Session Over" && paplay /usr/share/sounds/freedesktop/stereo/complete.oga &'
# alias emacs='emacsclient -nc -a ""'
# alias todo='${EDITOR:-nvim} -c ":cd $HOME/playground/projects/org_files" $HOME/playground/projects/org_files/refile.org +$'
# alias ftodo='file=$(rg --line-number --no-heading --with-filename "\*+ TODO" $HOME/playground/projects/org_files | fzf -d ":" --prompt "Find Todo: " --with-nth "3.." --layout=reverse --height=50% --ansi --border | sed -E "s/(.*):([0-9]+):.*/\1 +\2/") && [[ -n $file ]] && ${EDITOR:-nvim} -c ":cd $HOME/playground/projects/org_files" $file'
# alias note='${EDITOR:-nvim} -c ":cd $HOME/playground/projects/second_brain | set wrap linebreak" $HOME/playground/projects/second_brain/Notes/inbox.md +$'
# alias fnote='file=$(find $HOME/playground/projects/second_brain/ -type f -not -path "*.git*" -a -not -path "*/attachments/*" -a -not -path "*/.obsidian/*" -a -not -path "*/.stfolder/*" -a -not -path "*/.trash/*" | fzf --prompt "Find Note: " --layout=reverse --height=50% --ansi --border) && [[ -n $file ]] && ${EDITOR:-nvim} -c ":cd $HOME/playground/projects/second_brain | set wrap linebreak" $file'
# alias n='NVIM_APPNAME=my_nvim nvim'
alias fkill='for instanceId in $(flatpak ps --columns=instance | sed "1d"); do flatpak kill "${instanceId}"; done'
alias gcc='gcc -Wall -Wextra -Wpedantic -pedantic-errors -Wno-unused-variable -Wno-unused-parameter -g -fmax-errors=1 -Wfatal-errors -D_GLIBCXX_DEBUG -fsanitize=undefined -fsanitize=address'
alias starwars='nc towel.blinkenlights.nl 23'
alias rf="find . \( -path '*/venv' -o -path '*/__pycache__' \) -prune -o -type f -printf '%T@ %p\n' | sort -k1 -nr | awk '{ print \$NF; }; NR == 10 { exit; }'"
alias path='echo -e "${PATH//:/\\n}"'

# WSL
# alias chrome='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
# alias brave='/mnt/c/Program\ Files/BraveSoftware/Brave-Browser/Application/brave.exe'
# export SCREENDIR=$HOME/.screen
# service cron status &> /dev/null || sudo service cron start
alias wpwd='pwsh.exe -Command "Get-Location"'

# Nice to have
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"

# XDG
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Git commit signing
export GPG_TTY=$(tty)

# Scripts
[[ $PATH =~ ~/.local/bin ]] || export PATH="$HOME/.local/bin:$PATH"

# Fzf completion
export FZF_DEFAULT_OPTS='--border --layout=reverse --height=40% --info=right --cycle'
eval "$(fzf --bash)"
[[ -s $HOME/.config/fzf/fzf-git.sh ]] && \. "${HOME}/.config/fzf/fzf-git.sh"

# Directory jumper
eval "$(zoxide init bash)"

# Pyenv [Python version manager]
# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# NVM [Node version manager]
export NVM_DIR="$HOME/.config/nvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && \. "${NVM_DIR}/nvm.sh"
[[ -s "${NVM_DIR}/bash_completion" ]] && \. "${NVM_DIR}/bash_completion"

# Cargo [Rust]
[[ -s $HOME/.cargo/env ]] && \. "$HOME/.cargo/env"

# Go
[[ -d $HOME/go/bin && ! $PATH =~ $HOME/go/bin ]] && export PATH="$HOME/go/bin:${PATH}" 

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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
