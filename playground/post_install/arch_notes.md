# Arch Notes

- `rfkill unblock all`: iwctl device to power on
- `git clone https://aur.archlinux.org/yay.git`: AUR helper
    - `cd yay && makepkg -si`: installing yay
- `yay -s envycontrol`: install envycontrol
- `envycontrol -s integrated`: switch graphics to integrated only
- `sudo vim /usr/share/X11/xorg.conf.d/40-libinput.conf`: add options for touchpad

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
