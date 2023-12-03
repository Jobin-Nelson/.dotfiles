#
# ~/.bash_profile
#

if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
  export MOZ_ENABLE_WAYLAND=1
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Rust
[[ -d $HOME/.cargo/env ]] && \. "$HOME/.cargo/env"

