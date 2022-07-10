# Environment variables
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Options
set -o vi
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# Prompt
force_color_prompt=yes
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
unset force_color_prompt

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

# Nice to have
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Setting editor
export EDITOR='/usr/bin/nvim'
export VISUAL='/usr/bin/nvim'

# Scripts
if [ -d "$HOME/scripts" ] ; then
    PATH="$HOME/scripts:$PATH"
fi

# Pyenv [Python version manager]
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Nvm [Node version manager]
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Directory jumper
eval "$(zoxide init bash)"

# Cargo [Rust]
. "$HOME/.cargo/env"

# Functions
dev() {
    if ! tmux has-session -t Rappel; then
        cd ~/playground/dev/Rappel
        tmux new -s Rappel -d
        tmux new-window -t Rappel:1
        tmux rename-window -t Rappel:0 Editor
        tmux rename-window -t Rappel:1 Flask
        tmux send-keys -t Rappel:0 '. venv/bin/activate' Enter
        tmux send-keys -t Rappel:1 '. venv/bin/activate' Enter
        tmux send-keys -t Rappel:0 'nvim' Enter
        tmux select-window -t Rappel:0
    fi
    tmux attach -t Rappel
}

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
