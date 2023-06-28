#
# ~/.bash_profile
#

if [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
  export MOZ_ENABLE_WAYLAND=1
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
. "$HOME/.cargo/env"
