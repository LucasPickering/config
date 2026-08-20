#!/usr/bin/env fish

set script_dir (dirname (realpath (status filename)))

cd $script_dir

function delete_and_link -a link_path -a dest_path
    mkdir -p (dirname $link_path)
    rm -rf $link_path
    ln -s $script_dir/$dest_path $link_path
end

git submodule init

# Dprint
echo "Initializing dprint..."
delete_and_link ~/.config/dprint/dprint.jsonc dprint.jsonc

# Fish
echo "Initializing fish..."
delete_and_link ~/.config/fish fish
echo "  You'll need to set fish as your shell manually. Then run \`fisher update\`"

# Git
echo "Initializing git..."
delete_and_link ~/.gitconfig gitconfig

# Ghostty
echo "Initializing ghostty..."
delete_and_link ~/.config/ghostty/config ghostty/config.ghostty
# Link OS-specific ghostty config
switch (uname)
    case Linux
        delete_and_link ~/.config/ghostty/system.ghostty ghostty/linux.ghostty

    case Darwin
        delete_and_link ~/.config/ghostty/system.ghostty ghostty/macos.ghostty
end

# Helix
echo "Initializing helix..."
delete_and_link ~/.config/helix helix

# Htop
echo "Initializing htop..."
delete_and_link ~/.config/htop/htoprc htoprc

# Jujutsu
echo "Initializing jj..."
delete_and_link ~/.config/jj/config.toml jj.toml

# Mise
echo "Initializing mise..."
delete_and_link ~/.config/mise/config.toml mise_config.toml

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
delete_and_link ~/.cargo/config.toml cargo/config.toml
delete_and_link ~/.cargo/cargo-generate.toml cargo/cargo-generate.toml

echo "keyd: to initialize, run ./keyd/init.sh"
