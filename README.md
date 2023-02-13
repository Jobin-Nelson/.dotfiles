# Dotfiles

- Setup ssh key with github
- `git clone --depth 5 --bare git@github.com:Jobin-Nelson/.dotfiles.git $HOME/.dotfiles`
- `alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`
- `dot config --local status.showUntrackedFiles no`
- `dot checkout`

## Post Install

### Arch linux

```
cd /home/jobin/playground/post_install
./arch_post_install.sh
```

### Ubuntu & derivatives

```
cd /home/jobin/playground/post_install
./make_life_easy.sh
```

if running on WSL

```
WSL=1 $HOME/make_life_easy.sh
```

## Install packages

- `sudo apt-get -y install alacritty tmux zoxide git`
- [pyenv](https://github.com/pyenv/pyenv)
- [nvm](https://github.com/nvm-sh/nvm)
- [rust](https://rustup.rs/)
- [neovim](https://github.com/neovim/neovim)
- [starship](https://starship.rs/)

## I3WM

- Set Natural Scrolling and tapping for trackpad by editing `/usr/share/X11/xorg.conf.d/40-libinput.conf`

```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "True"
        Option "Tapping" "on"
EndSection
```

- Disable dunst notification shortcut `cntrl+tilde`
    - `sudo vi /etc/xdg/dunst/dunstrc`
    - change history line to `mod4+shift+grave`
    - `pkill dunst`
    - `dunstctl set-paused false`


