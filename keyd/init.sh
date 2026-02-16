#!/bin/sh


script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo mkdir -p /etc/keyd/
sudo ln -f -s $script_dir/default.conf /etc/keyd/default.conf

mkdir -p ~/.config/keyd/
ln -f -s $script_dir/app.conf ~/.config/keyd/app.conf

# keyd-application-mapper can't run in systemd, needs
# to go in the x server init
# https://github.com/rvaiya/keyd/issues/104
bin="/usr/bin/keyd-application-mapper"
file=~/.xprofile
touch $file
grep -q $bin $file || echo "$bin -d" >> $file
