# Welcome to my dotfiles

This is a collection of all my configuration files for stuff like nixos, sway, zed, tmux, zsh, etc.

## NixOS Configuration

After installing NixOS, make sure `/etc/nixos/hardware-configuration.nix` is present.

In order to use the configuration, either run the following:

```bash
sudo nixos-rebuild switch -I nixos-config=/path/to/configuration.nix
```

or import the configuration in your existing `/etc/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  imports =
    [
      /path/to/configuration.nix
    ];
}
```
