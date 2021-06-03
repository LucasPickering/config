#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $script_dir

delete_and_link() {
    link_path=$1
    dest_path=$2
    rm -rf $link_path
    ln -s $script_dir/$dest_path $link_path
}

git submodule init
git submodule update

# Fish
echo "Initializing fish..."
mkdir -p ~/.config
delete_and_link ~/.config/fish fish
echo "  You'll need to install fish and set it as your shell manually. Then run `fisher update`"

# SSH
echo "Initializing SSH config..."
mkdir -p ~/.ssh
delete_and_link ~/.ssh/config ssh/config

# Git
echo "Initializing git..."
delete_and_link ~/.gitconfig gitconfig

# Vim
echo "Initializing Vim..."
delete_and_link ~/.vim vim

# Tmux
echo "Initializing tmux..."
mkdir -p ~/.tmux/plugins
delete_and_link ~/.tmux.conf tmux/tmux.conf
delete_and_link ~/.tmux/plugins/tpm tmux/tpm
echo "  Press <shortcut>+I to load tmux plugins"
