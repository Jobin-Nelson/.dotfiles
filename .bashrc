#!/usr/bin/bash
#
# ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
# ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
# ██████╔╝███████║███████╗███████║██████╔╝██║
# ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
# ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
# ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#


# shellcheck disable=SC1091 # Disable errors when sourcing files
# If not running interactively, exit early
[[ $- == *i* ]] || return


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                    Global Variables                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# XDG
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Environment variables
HISTCONTROL=ignoreboth
HISTTIMEFORMAT='[%Y/%m/%d %T] '
HISTSIZE=10000
HISTFILESIZE=10000
PROMPT_DIRTRIM=2

# Prompt
PS1='\n[\[\033[01;32m\]\u@\[\033[35m\]\h\[\033[00m\]]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '

# Setting general variables
export EDITOR='nvim'
export VISUAL='nvim'
export COLORTERM="truecolor"
export MANPAGER='less -R --use-color -Dd+r -Du+b'
# export MANPAGER='nvim +Man!'
export SCREENRC="${XDG_CONFIG_HOME}/screen/screenrc"

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Git commit signing
export GPG_TTY
GPG_TTY=$(tty)

# Python old repl
export PYTHON_BASIC_REPL=1


# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                         Options                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


stty -ixon # avoid freezing terminal when pressing <c-s>
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
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias eup='${EDITOR:-vim} \
  $HOME/playground/dev/illumina/daily_updates/$(date -d \
  "$([[ $(date -d "+2 hours" +%u) -gt 5 ]] \
  && echo "next Monday" || echo "+2 hours")" +%Y-%m-%d).md'
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
alias todo='${EDITOR:-vim} -c ":cd $HOME/playground/projects/org_files" \
  $HOME/playground/projects/org_files/refile.org +$'
alias ftodo='rg --line-number --no-heading --with-filename \
  "\*+ TODO" $HOME/playground/projects/org_files \
  | fzf -d ":" --prompt "Find Todo: " --with-nth "3.." \
  --layout=reverse --height=50% --ansi \
  | sed -E "s/(.*):([0-9]+):.*/\1 +\2/" \
  | xargs -r ${EDITOR:-vim} -c ":cd $HOME/playground/projects/org_files"'
alias note='${EDITOR:-vim} -c ":cd $HOME/playground/projects/second_brain \
  | set wrap linebreak" $HOME/playground/projects/second_brain/Notes/inbox.md +$'
alias fnote='find $HOME/playground/projects/second_brain/ \
  -type f -not -path "*.git*" -a -not -path "*/attachments/*" \
  -a -not -path "*/.obsidian/*" -a -not -path "*/.stfolder/*" \
  -a -not -path "*/.trash/*" \
  | fzf --prompt "Find Note: " --layout=reverse --height=50% --ansi \
  | xargs -r ${EDITOR:-vim} -c ":cd $HOME/playground/projects/second_brain \
  | set wrap linebreak"'
alias dc='docker ps -a | fzf --multi --nth 2 --bind "enter:become(echo -n {+1})"'
alias pi="pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias ai="paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S"
alias pr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
alias ar="paru -Qq | fzf --multi --preview 'paru -Qi {1}' | xargs -ro paru -Rns"
alias ap='$(compgen -c | sort -u | fzf)'
alias lg="fzf --disabled --ansi --multi \
  --prompt='ripgrep> ' \
  --height 90% \
  --delimiter : \
  --header='CTRL-G: Toggle between ripgrep/fzf' \
  --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
  --preview-window '~4,nohidden,+{2}+4/3,<80(up)' \
  --bind='start:reload:rg --column --line-number --no-heading --color=always --smart-case {q} || :' \
  --bind='change:reload:sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case {q} || :' \
  --bind='enter:become:(( \$FZF_SELECT_COUNT == 0 )) && \${EDITOR:-vim} {1} +{2} || \${EDITOR:-vim} +cw -q {+f}' \
  --bind='ctrl-o:execute:(( \$FZF_SELECT_COUNT == 0 )) && \${EDITOR:-vim} {1} +{2} || \${EDITOR:-vim} +cw -q {+f}' \
  --bind='ctrl-g:transform:[[ ! \$FZF_PROMPT =~ ripgrep ]] && \
          echo \"rebind(change)+change-prompt(ripgrep> )+disable-search+transform-query:echo \{q} \
          > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r\" || \
          echo \"unbind(change)+change-prompt(fzf> )+enable-search+transform-query:echo \{q} \
          > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f\"' \
  --query "

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
# ┃                        Functions                         ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


function memtop() {
  local i
  {
    echo "PID Name Memory"
    for i in /proc/[0-9]*; do
      echo -e "${i##*/}\t$(<"${i}/comm")\t$(grep -oP 'VmRSS:\s*\K\d+ kB' "${i}/status")"
    done \
      | sort -nrk3 \
      | head "-$(( ${LINES:-24} - 4 ))"
  } | column -t
} 2>/dev/null

function rwl() {
  local wallpaper
  wallpaper=$(find "$HOME/Pictures/wallpapers" -type f \
    -name '*.png' -or -name '*.jpg' \
    | shuf -n 1)

  case "${XDG_CURRENT_DESKTOP}" in
    "GNOME")
      gsettings set org.gnome.desktop.background picture-uri-dark "file://${wallpaper}" ;;
    "Hyprland")
      reload.sh -p "${wallpaper}" ;;
    "KDE")
      reload.sh -k "${wallpaper}" ;;
    *)
      echo "Not implemented for ${XDG_CURRENT_DESKTOP}" >&2 ;;
  esac
}

function fgf() {
  local -r prompt_add="Add > "
  local -r prompt_reset="Reset > "

  local -r git_root_dir=$(git rev-parse --show-toplevel)
  local -r git_unstaged_files="git ls-files --modified --deleted --other --exclude-standard --deduplicate $git_root_dir"

  # shellcheck disable=SC2016
  local -r git_staged_files='git status --short | grep "^[A-Z]" | awk "{print \$NF}"'

  local -r git_reset="git reset -- {+}"
  local -r enter_cmd="($git_unstaged_files | grep {} && git add {+}) || $git_reset"

  local -r preview_status_label=" Status "
  local -r preview_status="git status --short"

  local -r header=$(cat <<EOF
> CTRL-G to switch between Add Mode and Reset mode
> CTRL-T for status preview | CTRL-F for diff preview | CTRL-B for blame preview
> ALT-E to open files in your editor
> ALT-C to commit | ALT-A to append to the last commit
EOF
  )

  local -r add_header=$(cat <<EOF
$header
> ENTER to add files
> ALT-P to add patch
EOF
  )

  local -r reset_header=$(cat <<EOF
$header
> ENTER to reset files
> ALT-D to reset and checkout files
EOF
  )

  local -r mode_reset="change-prompt($prompt_reset)+reload($git_staged_files)+change-header($reset_header)+unbind(alt-p)+rebind(alt-d)"
  local -r mode_add="change-prompt($prompt_add)+reload($git_unstaged_files)+change-header($add_header)+rebind(alt-p)+unbind(alt-d)"

  # shellcheck disable=SC2016
  eval "$git_unstaged_files" | fzf \
  --height=60% \
  --multi \
  --no-sort \
  --prompt="Add > " \
  --preview-label="$preview_status_label" \
  --preview="$preview_status" \
  --preview-window='nohidden' \
  --header "$add_header" \
  --header-first \
  --bind='start:unbind(alt-d)' \
  --bind="ctrl-t:change-preview-label($preview_status_label)" \
  --bind="ctrl-t:+change-preview($preview_status)" \
  --bind='ctrl-f:change-preview-label( Diff )' \
  --bind='ctrl-f:+change-preview(git diff --color=always {} | sed "1,4d")' \
  --bind='ctrl-b:change-preview-label( Blame )' \
  --bind='ctrl-b:+change-preview(git blame --color-by-age {})' \
  --bind="ctrl-g:transform:[[ \$FZF_PROMPT =~ '$prompt_add' ]] && echo '$mode_reset' || echo '$mode_add'" \
  --bind="enter:execute($enter_cmd)" \
  --bind="enter:+reload([[ \$FZF_PROMPT =~ '$prompt_add' ]] && $git_unstaged_files || $git_staged_files)" \
  --bind="enter:+refresh-preview" \
  --bind='alt-p:execute(git add --patch {+})' \
  --bind="alt-p:+reload($git_unstaged_files)" \
  --bind="alt-d:execute($git_reset && git checkout {+})" \
  --bind="alt-d:+reload($git_staged_files)" \
  --bind='alt-c:execute(git commit)+abort' \
  --bind='alt-a:execute(git commit --amend)+abort' \
  --bind='alt-e:execute(${EDITOR:-vim} {+})'
}

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
  --style=full \
  --info=inline-right \
  --multi \
  --layout=reverse \
  --height=40% \
  --cycle \
  --bind='f1:toggle-header' \
  --bind='f2:execute(bat --style=numbers {} || less -f {})' \
  --bind='f3:toggle-preview-wrap' \
  --bind='f4:toggle-preview' \
  --bind='f5:change-preview-window(up,40%|left,60%|down,40%|right,60%)' \
  --bind='f6:change-preview-window(down,40%|left,60%|up,40%|right,60%)' \
  --bind='shift-down:preview-half-page-down,shift-up:preview-half-page-up' \
  --bind='alt-a:toggle-all' \
  --bind='alt-g:first,alt-G:last' \
  --bind='ctrl-f:half-page-down,ctrl-b:half-page-up' \
  --bind='ctrl-q:select-all+accept' \
  --bind='ctrl-x:jump' \
  --bind='ctrl-y:execute-silent(echo {+} | xclip -sel clip -r)'"
eval "$(fzf --bash)"

[[ -s ${XDG_CONFIG_HOME}/fzf/fzf-git.sh ]] && \. "${XDG_CONFIG_HOME}/fzf/fzf-git.sh"
[[ -s ${XDG_CONFIG_HOME}/fzf/fzf-comp.sh ]] && \. "${XDG_CONFIG_HOME}/fzf/fzf-comp.sh"


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
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
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
