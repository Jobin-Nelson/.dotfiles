# if running bash interactively load bashrc
if [[ -n $BASH_VERSION && -n $PS1 ]]; then
  if [[ -f $HOME/.bashrc ]]; then
    . "${HOME}/.bashrc"
  fi
fi
