# dotfiles

This repo contains configuration files which allow me to quickly configure a machine to my liking.

GNU Stow should be used to manage the symlinks for the files.

<!-- screenfetch -->
```text
                 -/+:.          f@Dorado
                :++++.          OS: 64bit macOS  
               /+++/.           Kernel: arm64 Darwin 24.6.0
       .:-::- .+/:-``.::-       Uptime: 8d 3h 9m
    .:/++++++/::::/++++++/:`    Packages: 256
  .:///////////////////////:`   Shell: zsh 5.9
  ////////////////////////`     Resolution: 2560x1440, 2560x1440 
 -+++++++++++++++++++++++`      DE: Aqua
 /++++++++++++++++++++++/       WM: Quartz Compositor
 /sssssssssssssssssssssss.      WM Theme: Blue
 :ssssssssssssssssssssssss-     Font: SFMonoRegular
  osssssssssssssssssssssssso/`  Disk: 544G / 995G (55%)
  `syyyyyyyyyyyyyyyyyyyyyyyy+`  CPU: Apple M4 Pro
   `ossssssssssssssssssssss/    GPU: Apple M4 Pro 
     :ooooooooooooooooooo+.     RAM: 4547MiB / 49152MiB
      `:+oo+/:-..-:/+o+/-      
```

## Installation

One liner:

```sh
git clone https://github.com/fbuetler/dotfiles.git ~/.dotfiles \
    && cd ~/.dotfiles \
    && stow {zsh,profile,vim,neovim,alacritty,git,ssh,fd,jq,ripgrep,tmux,gnupg,vscode,firefox,vimium}
```

Additionally,

* MacOS: `stow {aerospace,sketchybar,jankyborders,Stats}` (manual `keyboard`)
* Linux: `stow {sway,swaync,waybar,rofi,dunst,defaultapps,restic}`

Fine-grained:

```sh
# Example: uninstall vim configuration
$ stow -D vim

# Example: reinstall vim configuration
$ stow -R vim
```

Currently unused:

* `psql`
* `ranger`
* `swap-y-z`
