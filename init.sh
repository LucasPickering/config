#!/bin/sh

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

# Fish
echo "Initializing fish..."
mkdir -p ~/.config
delete_and_link ~/.config/fish fish
echo "  You'll need to install fish and set it as your shell manually. Then run \`fisher update\`"

# Git
echo "Initializing git..."
delete_and_link ~/.gitconfig gitconfig

# Vim
echo "Initializing Vim..."
delete_and_link ~/.vim vim

# Psql
echo "Initializing psql..."
delete_and_link ~/.psqlrc psqlrc

# Zed
echo "Initializing Zed..."
delete_and_link ~/.config/zed zed

echo "Initializing Cargo..."
mkdir -p ~/.cargo
delete_and_link ~/.cargo/config.toml cargo/config.toml
delete_and_link ~/.cargo/cargo-generate.toml cargo/cargo-generate.toml
