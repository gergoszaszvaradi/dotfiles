# Welcome to my dotfiles

This is a collection of all my configuration files for stuff like nixos, emacs, tmux, zsh, etc.

## NixOS Configuration

After installing NixOS, make sure `/etc/nixos/hardware-configuration.nix` is present.

In order to build the configuration, run the following:

```bash
sudo nixos-rebuild switch -I nixos-config=/path/to/configuration.nix
```

## Stow

Everything in `home/` is controlled with [GNU stow](https://www.gnu.org/software/stow/).

The NixOS configuration above provides a `stow` command that can be used to manage the dotfiles.

Since the stow packages are not in the root of the repository, a target directory must be specified.

```bash
stow -t ~ <package>
```
