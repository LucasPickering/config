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
echo "source ~/.bash/bashrc.sh" >> $bash_file

echo "Initializing SSH config..."
delete_and_link ~/.ssh ssh

# Git
echo "Initializing git..."
delete_and_link ~/.gitconfig gitconfig

# Vim
echo "Initializing Vim..."
delete_and_link ~/.vim vim

# Tmux
echo "Initializing tmux..."
delete_and_link ~/.tmux.conf tmux/tmux.conf
mkdir -p ~/.tmux/plugins
delete_and_link ~/.tmux/plugins/tpm tmux/tpm
