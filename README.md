# Welcome to my dotfiles

This is a collection of all my configuration files for stuff like emacs, tmux, zsh, etc.

Everything in here is controlled with [GNU stow](https://www.gnu.org/software/stow/).

# Usage

## Prerequisites

Install GNU stow for the full experience.

``` sh
sudo dnf install stow
```

## Symlinking the configs

For each package in the repo that you want symlinked, run `stow <package>`.

> [!WARNING] 
> Make sure you back up your configs just in case. Stow should not touch anything if there are conflicts.

### Doom Emacs

In case you don't have doom emacs ready yet:

``` sh
sudo dnf install emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install
```

To use the doom configs:

``` sh
stow doom
```

### Tmux

In case you don't have tpm installed yet:

``` sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

To use the tmux configs:

``` sh
stow tmux
```

### ZSH

In case you don't have zsh installed yet:

``` sh
sudo dnf install zsh
```

To use the zsh configs:

``` sh
stow zsh
```

You might face some issues since installing zsh will create the .zshrc that need to be stowed. If so, delete them first from you home directory and then run stow.

### Solaar

I'm using a Logitech MX Master 3S and on linux, solaar is the best way to configure it.

``` sh
stow solaar
```

This adds some rules I use to remap the side buttons on the mouse.

### Nano

Nano is installed on any linux distro, so a good config does not hurt.

``` sh
stow nano
```
