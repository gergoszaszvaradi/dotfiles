#!/bin/sh
set -e
pushd /home/gergoszaszvaradi/.dotfiles/nixos
nano configuration.nix
git diff -U0 *.nix
read -r -p "Are you sure to rebuild and switch? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "NixOS Rebuilding..."
    nixos-rebuild switch -I nixos-config=/home/gergoszaszvaradi/.dotfiles/nixos/configuration.nix
    gen=$(nixos-rebuild list-generations | grep current)
    git commit -am "$gen"
    read -r -p "Push changes to origin? " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        git push
    fi
fi
popd
