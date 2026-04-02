#!/bin/sh


script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo rm -f /etc/keyd
sudo ln -s $script_dir/configs /etc/keyd

mkdir -p ~/.config/keyd/
ln -f -s $script_dir/app.conf ~/.config/keyd/app.conf
if id -nG "$USER" | grep -qw "keyd"; then
  sudo usermod -aG keyd lucas
  echo "You'll need to reboot to make the user group change take effect"
fi

# keyd-application-mapper can't run in systemd, needs
# to go in KDE autostart
# https://github.com/rvaiya/keyd/issues/104
autostart_dir="$HOME/.config/autostart"
mkdir -p $autostart_dir
cat > "$autostart_dir/keyd-application-mapper.desktop" <<EOF
[Desktop Entry]
Type=Application
Exec=/usr/bin/keyd-application-mapper
Hidden=false
NoDisplay=false
X-KDE-Autostart-enabled=true
Name=Keyd Application Mapper
Comment=Start keyd application mapper
EOF
