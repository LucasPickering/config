#!/bin/sh


script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo rm -rf /etc/keyd/
sudo ln -s $script_dir/configs /etc/keyd

mkdir -p ~/.config/keyd/
ln -f -s $script_dir/app.conf ~/.config/keyd/app.conf
if id -nG "$USER" | grep -qw "keyd"; then
  sudo usermod -aG keyd lucas
  echo "You'll need to reboot to make the user group change take effect"
fi

# keyd-application-mapper can't run in systemd, needs
# to go in the x server init
# https://github.com/rvaiya/keyd/issues/104
bin="/usr/bin/keyd-application-mapper"
file=~/.xprofile
touch $file
grep -q $bin $file || echo "$bin -d" >> $file
