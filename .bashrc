# Environment variables
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000

# Options
set -o vi
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob

# Prompt
PS1='\n[\[\033[01;32m\]\u@\[\033[35m\]\h\[\033[00m\]]: \[\033[01;34m\]\w\[\033[00m\]\n\$ '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alFh --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -i -R'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias eup="/usr/bin/nvim \$HOME/playground/dev/illumina/daily_updates/\$(date -d \"\$([[ \$(date -d '+6 hours' +%u) -gt 5 ]] && echo 'next Monday' || echo '+6 hours')\" '+%Y-%m-%d').txt"
alias bt="upower -i \$(upower -e | grep 'BAT') | grep -E \"state|to full|percentage\""
alias wl='nsxiv $HOME/Pictures/wallpapers'
# alias rwl="feh --randomize --bg-scale \$HOME/Pictures/wallpapers/*"
alias rwl='gsettings set org.gnome.desktop.background picture-uri-dark file://$(find $HOME/Pictures/wallpapers -type f | shuf -n 1)'
alias docker='podman'

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

# Scripts
case ":${PATH}:" in
    *:"${HOME}/scripts":*)
        ;;
    *)
        [[ -d "$HOME/scripts" ]] && PATH="$HOME/scripts:$PATH";;
esac

# Fzf completion
[[ -s "$HOME/.config/fzf/key-bindings.bash" ]] && \. "$HOME/.config/fzf/key-bindings.bash" 
[[ -s "$HOME/.config/fzf/completion.bash" ]] && \. "$HOME/.config/fzf/completion.bash" 

# Pyenv [Python version manager]
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Directory jumper
eval "$(zoxide init bash)"

# Cargo [Rust]
. "$HOME/.cargo/env"

# Starship prompt
eval "$(starship init bash)"

# Greeting
cat << EOF
  .----------------.
  |  Hello Friend  |
  '----------------'
      ^      (\_/)
      '----- (O.o)
             (> <)
              " "
EOF

