# dotfiles

This repo contains configuration files which allow me to quickly configure a machine to my liking.

GNU Stow should be used to manage the symlinks for the files.

`````plain
                   -`
                  .o+`                 florian@Amberjack
                 `ooo/                 OS: Arch Linux
                `+oooo:                Kernel: x86_64 Linux 5.15.72-1-lts
               `+oooooo:               Uptime: 8d 19h 20m
               -+oooooo+:              Packages: 1785
             `/:-:++oooo+:             Shell: zsh 5.9
            `/++++/+++++++:            Resolution: 1920x1080
           `/++++++++++++++:           WM: i3
          `/+++ooooooooooooo/`         GTK Theme: Adwaita [GTK3]
         ./ooosssso++osssssso+`        Disk: 259G / 460G (60%)
        .oossssso-````/ossssss+`       CPU: Intel Core i7-7500U @ 4x 3.5GHz [58.0°C]
       -osssssso.      :ssssssso.      GPU: Intel Corporation HD Graphics 620 (rev 02)
      :osssssss/        osssso+++.     RAM: 6539MiB / 15765MiB
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/
`````

### Installation

One liner:

```sh
git clone --recurse-submodules https://github.com/jamespwilliams/dotfiles.git ~/.dotfiles \
    && cd ~/.dotfiles \
    && stow {zsh,readline,tmux,vim}
```

Longer:

```sh
$ git clone --recurse-submodules https://github.com/jamespwilliams/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ stow {zsh,readline,tmux,vim}

# Example: uninstall vim configuration
$ stow -D vim

# Example: reinstall vim configuration
$ stow -R vim
```
