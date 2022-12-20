# dotfiles

This repo contains configuration files which allow me to quickly configure a machine to my liking.

GNU Stow should be used to manage the symlinks for the files.

<!-- screenfetch -w  -->
```plain
                   -`
                  .o+`                 florian@Amberjack
                 `ooo/                 OS: Arch Linux
                `+oooo:                Kernel: x86_64 Linux 5.15.83-1-lts
               `+oooooo:               Uptime: 13m
               -+oooooo+:              Packages: 1765
             `/:-:++oooo+:             Shell: zsh 5.9
            `/++++/+++++++:            Resolution: 1920x1080
           `/++++++++++++++:           WM: sway
          `/+++ooooooooooooo/`         GTK Theme: Adwaita [GTK3]
         ./ooosssso++osssssso+`        Disk: 275G / 460G (63%)
        .oossssso-````/ossssss+`       CPU: Intel Core i7-7500U @ 4x 3.5GHz [61.0°C]
       -osssssso.      :ssssssso.      GPU: Intel Corporation HD Graphics 620 (rev 02)
      :osssssss/        osssso+++.     RAM: 4190MiB / 15765MiB
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/
```

### Installation

One liner:

```sh
git clone https://github.com/fbuetler/dotfiles.git ~/.dotfiles \
    && cd ~/.dotfiles \
    && stow {zsh,vim,alacritty,sway,waybar,vscode,git,ssh,dunst,gnupg,ranger,scripts}
```

Fine-grained:

```sh
# Example: uninstall vim configuration
$ stow -D vim

# Example: reinstall vim configuration
$ stow -R vim
```
