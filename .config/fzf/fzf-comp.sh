#!/usr/bin/bash
#
# ███████╗███████╗███████╗     ██████╗ ██████╗ ███╗   ███╗██████╗
# ██╔════╝╚══███╔╝██╔════╝    ██╔════╝██╔═══██╗████╗ ████║██╔══██╗
# █████╗    ███╔╝ █████╗      ██║     ██║   ██║██╔████╔██║██████╔╝
# ██╔══╝   ███╔╝  ██╔══╝      ██║     ██║   ██║██║╚██╔╝██║██╔═══╝
# ██║     ███████╗██║         ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║
# ╚═╝     ╚══════╝╚═╝          ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝
#


[[ $0 = - ]] && return

_fzf_complete_pass() {
  _fzf_complete -- "$@" < <(pass git ls-files | sed \
    -e '/.gitattributes/d' \
    -e '/.gpg-id/d' \
    -e 's/.gpg$//' \
  )
}

# _fzf_complete_pass_post() {
#   post processing commands ...
# }

[ -n "$BASH" ] && complete -F _fzf_complete_pass -o default -o bashdefault pass
