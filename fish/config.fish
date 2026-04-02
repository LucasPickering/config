# Install fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

alias src="source ~/.config/fish/config.fish"

alias ports="sudo lsof -i -P -n | rg LISTEN"
alias c="cargo"
alias cdroot="cd (git root)"
alias d="docker"
alias dc="docker-compose"
alias erd="erd --human --layout inverted"
alias g="git"
alias gl="gleam"
alias jc="journalctl"
alias k="kubectl"
alias kdp='kubectl describe pod'
alias kgp='kubectl get pods'
alias kl='kubectl logs --follow'
alias m="mise"
alias npx="npx --no-install"
alias pasta="paste" # Extremely important
alias repeat="~/.config/fish/functions/repeat.py"
alias repl="evcxr" # I just cannot remember this command
alias sc="systemctl"
alias sl="slumber"
alias tf='tofu'
alias y="yazi"
alias z="zed"

set -Ux HOMEBREW_NO_AUTO_UPDATE 1
set -Ux VIMINIT "source ~/.vim/vimrc"
set -gx EDITOR hx
set -gx SUDO_EDITOR hx
source ~/.config/fish/functions/custom.fish

# Keybindings
bind super-backspace backward-kill-line
bind alt-backspace backward-kill-word
bind ctrl-k up-or-search
bind ctrl-j down-or-search
bind ctrl-h beginning-of-line
bind ctrl-l end-of-line
bind alt-h backward-word
bind alt-l forward-word

# OS-specific setup
switch (uname)
    case Linux
        # Ubuntu uses xsel, NixOS uses xclip
        if type -q xsel
            alias copy="xsel -ib"
            alias paste="xsel -ob"
        else if type -q xclip
            alias copy="xclip -sel -i"
            alias paste="xclip -o"
        end

        set -Ux GPG_TTY (tty)
        # https://forum.manjaro.org/t/howto-use-kwallet-as-a-login-keychain-for-storing-ssh-key-passphrases-on-kde/7088
        set -Ux SSH_ASKPASS /usr/bin/ksshaskpass
        set -Ux SSH_AUTH_SOCK "$XDG_RUNTIME_DIR"/ssh-agent.socket

    case Darwin
        alias copy="pbcopy"
        alias paste="pbpaste"
        fish_add_path /opt/homebrew/bin
        fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
end

if test -d ~/.krew
    fish_add_path ~/.krew/bin
end

if test -d ~/.cargo
    fish_add_path ~/.cargo/bin
end

if type -q es
    es --shell fish init | source
end

if type -q mise
    mise activate fish | source
end

if type -q slumber
    source (COMPLETE=fish slumber | psub)
end

# Load additional config based on hostname
set host_config ~/.config/fish/config.(hostname_base).fish
test -r $host_config; and source $host_config

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
