#!/usr/bin/bash
#  _               _              
# | |__   __ _ ___| |__  _ __ ___ 
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__ 
# |_.__/ \__,_|___/_| |_|_|  \___|
#


# If not running interactively, exit early
[[ $- == *i* ]] || return


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Global Variables                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# Environment variables
HISTCONTROL=ignoreboth
HISTTIMEFORMAT='[%Y/%m/%d %T] '
HISTSIZE=10000
HISTFILESIZE=10000
PROMPT_DIRTRIM=2

# Prompt
PS1='\n[\[\033[01;32m\]\u@\[\033[35m\]\h\[\033[00m\]]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '

# XDG
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Setting editor
export EDITOR='nvim'
export VISUAL='nvim'
export COLORTERM="truecolor"
export MANPAGER='less -R --use-color -Dd+r -Du+b'
# export MANPAGER='nvim +Man!'
export SCREENRC="${HOME}/.config/screen/screenrc"

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Git commit signing
export GPG_TTY=$(tty)


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Options                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


set -o vi
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob
shopt -s cdspell


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                        Keybinds                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# General
bind "set colored-stats On"
bind "set colored-completion-prefix On"
bind "set completion-ignore-case On"

# Change mode
bind -m emacs-standard '"\C-z": vi-editing-mode'
bind -m vi-command     '"\C-z": emacs-editing-mode'
bind -m vi-insert      '"\C-z": emacs-editing-mode'

# Expand subshell
bind -m vi-insert '"\C-e": "\C-z\e\C-e\er\C-z"'


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Aliases                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# General
alias ls='ls --color=auto'
alias ll='ls -alFh --group-directories-first --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias less='less -i -R'
alias path='echo -e "${PATH//:/\\n}"'
alias alert='notify-send --urgency=low -i \
  "$([ $? = 0 ] && echo terminal || echo error)" \
  "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bt="upower -i \$(upower -e | grep 'BAT') \
  | grep -E \"state|to full|percentage|time to empty\""
alias vl="pactl list sinks | grep 'Volume'"
alias pomo='sleep 1h && notify-send "Focus Session Over" \
  && paplay /usr/share/sounds/freedesktop/stereo/complete.oga &'

# Wallpaper
alias wl='nsxiv $HOME/Pictures/wallpapers/**/*'
alias twl='nsxiv $HOME/Pictures/wallpapers/$(date +%F)'

# Custom
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias eup='${EDITOR:-nvim} \
  $HOME/playground/dev/illumina/daily_updates/$(date -d \
  "$([[ $(date -d "+6 hours" +%u) -gt 5 ]] \
  && echo "next Monday" || echo "+6 hours")" +%Y-%m-%d).md'
alias rwl='w=$(\
  find $HOME/Pictures/wallpapers -type f -name '"'"'*.png'"'"' -or -name '"'"'*.jpg'"'"' \
  | shuf -n 1) \
  && if [[ $XDG_CURRENT_DESKTOP == "GNOME" ]]; then \
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$w"; \
  elif [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then \
  reload.sh -p $w; \
  elif [[ $XDG_CURRENT_DESKTOP == "KDE" ]]; then \
  reload.sh -k "$w"; \
  else echo "Not implemented for ${XDG_CURRENT_DESKTOP}"; fi'
alias fkill='flatpak ps --columns=instance | xargs -rn1 flatpak kill'
alias gcc='gcc -Wall -Wextra -Wpedantic -pedantic-errors -Wno-unused-variable \
  -Wno-unused-parameter -g -fmax-errors=1 -Wfatal-errors -D_GLIBCXX_DEBUG \
  -fsanitize=undefined -fsanitize=address'
alias starwars='nc towel.blinkenlights.nl 23'
alias rf="find . \( -path '*/venv' -o -path '*/__pycache__' -o -path '*/.git' \) \
  -prune -o -type f -printf '%T@ %p\n' | sort -k1 -nr \
  | awk '{ print \$NF; }; NR == 10 { exit; }'"
alias rr='until eval $(history -p '"'"'!!'"'"'); do \
  sleep 1; echo $'"'"'\nTrying again...\n'"'"'; done'

# FZF
alias todo='${EDITOR:-nvim} -c ":cd $HOME/playground/projects/org_files" \
  $HOME/playground/projects/org_files/refile.org +$'
alias ftodo='file=$(rg --line-number --no-heading --with-filename \
  "\*+ TODO" $HOME/playground/projects/org_files \
  | fzf -d ":" --prompt "Find Todo: " --with-nth "3.." \
  --layout=reverse --height=50% --ansi --border \
  | sed -E "s/(.*):([0-9]+):.*/\1 +\2/") && [[ -n $file ]] \
  && ${EDITOR:-nvim} -c ":cd $HOME/playground/projects/org_files" $file'
alias note='${EDITOR:-nvim} -c ":cd $HOME/playground/projects/second_brain \
  | set wrap linebreak" $HOME/playground/projects/second_brain/Notes/inbox.md +$'
alias fnote='file=$(find $HOME/playground/projects/second_brain/ \
  -type f -not -path "*.git*" -a -not -path "*/attachments/*" \
  -a -not -path "*/.obsidian/*" -a -not -path "*/.stfolder/*" \
  -a -not -path "*/.trash/*" | fzf --prompt "Find Note: " \
  --layout=reverse --height=50% --ansi --border) \
  && [[ -n $file ]] && ${EDITOR:-nvim} -c ":cd $HOME/playground/projects/second_brain \
  | set wrap linebreak" $file'
alias dc='docker ps -a | fzf --multi --nth 2 --bind "enter:become(echo -n {+1})"'
alias pi="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias pr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias ap='compgen -c | sort -u | fzf'
alias lg="fzf --disabled --ansi --multi \
  --bind 'start:reload:rg --column --line-number --no-heading --color=always --smart-case {q} || :' \
  --bind 'change:reload:rg --column --line-number --no-heading --color=always --smart-case {q} || :' \
  --bind 'enter:become:(( \$FZF_SELECT_COUNT == 0 )) && nvim {1} +{2} || nvim +cw -q {+f}' \
  --bind 'ctrl-o:execute:(( \$FZF_SELECT_COUNT == 0 )) && nvim {1} +{2} || nvim +cw -q {+f}' \
  --bind 'alt-a:select-all,alt-d:deselect-all' \
  --delimiter : \
  --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
  --preview-window '~4,nohidden,+{2}+4/3,<80(up)' \
  --height 90% --query "

# Obselete aliases
# alias emacs='emacsclient -nc -a ""'
# alias n='NVIM_APPNAME=my_nvim nvim'

# WSL
# alias chrome='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
# alias brave='/mnt/c/Program\ Files/BraveSoftware/Brave-Browser/Application/brave.exe'
# export SCREENDIR=$HOME/.screen
# service cron status &> /dev/null || sudo service cron start
# alias wpwd='pwsh.exe -Command "Get-Location"'


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    General Utilities                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# Nice to have
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"

# Scripts
[[ $PATH =~ ~/.local/bin ]] || export PATH="$HOME/.local/bin:$PATH"

# FZF completion
export FZF_DEFAULT_OPTS="\
  --select-1 \
  --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file \
  || (bat --style=numbers --color=always {} || cat {}) 2>/dev/null | head -300' \
  --preview-window='right:hidden:wrap' \
  --bind='f3:toggle-preview-wrap' \
  --bind='f4:toggle-preview' \
  --bind='f5:execute(bat --style=numbers {} || less -f {})' \
  --bind='shift-down:preview-page-down,shift-up:preview-page-up' \
  --bind='alt-a:select-all,alt-d:deselect-all' \
  --bind='alt-g:first,alt-G:last' \
  --bind='ctrl-f:half-page-down,ctrl-b:half-page-up' \
  --bind='ctrl-q:select-all+accept' \
  --bind='ctrl-x:jump' \
  --bind='ctrl-y:execute-silent(echo {+} | xclip -sel clip -r)' \
  --multi --border --layout=reverse --height=40% --info=inline-right --cycle"
eval "$(fzf --bash)"
[[ -s $HOME/.config/fzf/fzf-git.sh ]] && \. "${HOME}/.config/fzf/fzf-git.sh"

# Directory jumper
eval "$(zoxide init bash)"

# Starship prompt
eval "$(starship init bash)"

# Greeting
cat <<EOF
  .----------------------------------------------.
  |  The Force is strong with you, young mortal  |
  '----------------------------------------------'
      ^      (\_/)
      '----- (O.o)
             (> <)
              " "
EOF


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Language Configs                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# NVM [Node version manager]
export NVM_DIR="$HOME/.config/nvm"
[[ -s "${NVM_DIR}/nvm.sh" ]] && \. "${NVM_DIR}/nvm.sh"
[[ -s "${NVM_DIR}/bash_completion" ]] && \. "${NVM_DIR}/bash_completion"

# Cargo [Rust]
[[ -s $HOME/.cargo/env ]] && \. "$HOME/.cargo/env"

# Go
[[ -d $HOME/go/bin && ! $PATH =~ $HOME/go/bin ]] && export PATH="$HOME/go/bin:${PATH}" 

# Haskell
[[ -s "${HOME}/.ghcup/env" ]] && . "${HOME}/.ghcup/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
