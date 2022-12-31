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
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -i -R'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias eup="/usr/bin/nvim \$HOME/playground/dev/illumina/daily_updates/\$(date +%Y-%m-%d).txt"

# WSL
alias chrome='/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe'
alias brave='/mnt/c/Program\ Files/BraveSoftware/Brave-Browser/Application/brave.exe'
export SCREENDIR=$HOME/.screen
service cron status || sudo service cron start

# Nice to have
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Setting editor
export EDITOR='/usr/bin/nvim'
export VISUAL='/usr/bin/nvim'
export COLORTERM="truecolor"

# Scripts
[ -d "$HOME/scripts" ] && PATH="$HOME/scripts:$PATH"

# Pyenv [Python version manager]
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Nvm [Node version manager]
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Directory jumper
eval "$(zoxide init bash)"

# Cargo [Rust]
. "$HOME/.cargo/env"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Starship prompt
# eval "$(starship init bash)"

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

