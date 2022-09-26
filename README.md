# dotfiles

This repo contains configuration files which allow me to quickly configure a machine to my liking.

GNU Stow should be used to manage the symlinks for the files.

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
