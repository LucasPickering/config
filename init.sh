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
echo "source ~/.bash/bashrc" >> ~/.bashrc

# Git
echo "Initializing git..."
delete_and_link ~/.gitconfig gitconfig

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
delete_and_link $sublime_dir/Packages/User subl

# Vim
echo "Initializing Vim..."
delete_and_link ~/.vim vim
