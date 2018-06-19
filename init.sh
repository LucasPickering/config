#!/bin/bash

set -e

delete_and_link() {
    link_path=$1
    dest_path=$2
    rm -rf $link_path
    ln -s $dest_path $link_path
}

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $script_dir

git submodule init
git submodule update

# Bash
echo "Initializing bash..."
delete_and_link ~/.bash $script_dir/bash
echo "source ~/.bash/bashrc" >> ~/.bashrc

# Git
echo "Initializing git..."
delete_and_link ~/.gitconfig $script_dir/gitconfig

# Sublime
echo "Initializing Sublime..."
case "$(uname)" in
    "Darwin" )
        sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 3
    ;;
    "Linux" )
        sublime_dir=~/.config/sublime-text-3
    ;;
esac
delete_and_link $sublime_dir/Packages/User $script_dir/subl

# Vim
echo "Initializing Vim..."
delete_and_link ~/.vimrc $script_dir/vim/vimrc
