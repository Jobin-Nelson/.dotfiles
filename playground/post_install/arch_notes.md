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

## Snapshots

- btrfs
- `yay -S snapper snap-pac snapper-rollback grub-btrfs`: snapper takes advantage of btrfs format
- `su`: change to root user
- `umount /.snapshots`: if you have btrfs there is already a snapshot mounted
- `rmdir /.snapshots`: removes the snapshot directory
- `snapper -c root create-config /`: creates config for root folder
- `snapper ls`: to list all snapshots
- `nvim /etc/snapper/configs/root`: edit the snapper config

```
...
ALLOW_USERS=""
ALLOW_GROUPS="wheel"
...
TIME_LINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
...
```

- `btrfs subvol list /`: list all subvol under this directory
- `btrfs subvol get-default /`: gets the default subvol for this directory
- `btrfs subvol set-default {ID} /`: sets the default subvol to ID obtained from subvol list path @
- `btrfs subvol get-default /`: check if the default subvol has changed

- `systemctl enable --now grub-btrfs.path`: start grub-btrfs
- `systemctl enable --now snapper-timeline.timer`: start snapper-timeline
- `systemctl enable --now snapper-cleanup.timer`: start snapper-cleanup

- `snapper -c root create -d "BASE"`: create a snapshot manually
- `snapper ls`: list all snapshots
- `yay -S neofetch`: install a program to make changes
- `snapper status 1..3`: all changes from snapshot 1 to 3

- `sudo nvim /etc/initcpio/hooks/switchsnaprotorw`: since the snapshots are read only this is how you can boot into a snapshot with writable access

```bash
#!/usr/bin/bash

run_hook() {
	local current_dev=$(resolve_device "$root"); # resolve devices for blkid
	if [[ $(blkid ${current_dev} -s TYPE -o value) = "btrfs" ]]; then
		current_snap=$(mktemp -d); # create a random mountpoint in root of initrafms
		mount -t btrfs -o ro,"${rootflags}" "$current_dev" "${current_snap}";
		if [[ $(btrfs property get "${current_snap}" ro) != "ro=false" ]]; then # check if the snapshot is in read-only mode
			snaproot=$(mktemp -d);
			mount -t btrfs -o rw,subvolid=5 "${current_dev}" "${snaproot}";
			rwdir=$(mktemp -d)
			mkdir -p ${snaproot}${rwdir} # create a random folder in root fs of btrfs device
			btrfs sub snap "${current_snap}" "${snaproot}${rwdir}/rw";
			umount "${current_snap}";
			umount "${snaproot}"
			rmdir "${current_snap}";
			rmdir "${snaproot}";
			rootflags=",subvol=${rwdir}/rw";
		else
			umount "${current_snap}";
			rmdir "${current_snap}";
		fi
	fi
}
```

- `sudo nvim /etc/initcpio/install/switchsnaprotorw`

```bash
#!/bin/bash

build() {
    add_module btrfs
    add_binary btrfs
    add_binary btrfsck
    add_binary blkid
    add_runscript
}

help() {
    cat <<HELPEOF
This hook creates a copy of the snapshot in read only mode before boot.
HELPEOF
}
```

- `sudo nvim /etc/mkinitcpio.conf`: add the hook in the mkinitcpio config

```
...
HOOKS=(base udev autodetect keyboard keymap modconf block filesystem fsck switchsnaprotorw)
...
```

- `sudo mkinitcpio -P`: changes to take effect
- Now you can load snapshots from the boot menu itself

- `sudo nvim /etc/snapper/snapper-rollback.conf`: edit snapper-rollback config

```
...
subvol_snapshots=@.snapshots
...
dev=/dev/sda
# get the ^ filesystem path from /etc/fstab for root
...
```

- `sudo snapper-rollback 5`: rollback to snapshot 5
- `reboot`: reboot to finish

## Screensharing

- It is hard to screen share on wayland, switch to X11 to solve this issue
- `sudo vim /etc/gdm/custom.conf`: uncomment the line "#WaylandEnable = False"
- Restart to switch to X11
