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

# Bash
echo "Initializing bash..."
delete_and_link ~/.bash bash
case "$(uname)" in
    "Darwin" )
        bash_file=~/.bash_profile
    ;;
    "Linux" )
        bash_file=~/.bashrc
    ;;
esac
line_to_add="source ~/.bash/bashrc.sh"
# Only add the source line if it isn't there already
if [[ $(tail -n 1 $bash_file) != $line_to_add ]]; then
    echo "source ~/.bash/bashrc.sh" >> $bash_file
fi

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
echo "Press <shortcut>+I to install plugins"
