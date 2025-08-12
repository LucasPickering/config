# Install fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end


alias cdroot="cd (git root)"
alias src="source ~/.config/fish/config.fish"
alias repeat="~/.config/fish/functions/repeat.py"
alias nuke="rm -rf node_modules && npm install"
alias ports="sudo lsof -i -P -n | rg LISTEN"
alias nocolor="sed -E 's/\x1b\[[0-9;]*m//g'" # Strip ANSI colors from stdin
alias npx="npx --no-install"
alias c="cargo"
alias d="docker"
alias dc="docker-compose"
alias g="git"
alias k="kubectl"
alias kdp='kubectl describe pod'
alias kgp='kubectl get pods'
alias kl='kubectl logs --follow'
alias m="mise"
alias p="poetry"
alias pr="poetry run"
alias sl="slumber"
alias tf='terraform'
alias repl="evcxr" # I just cannot remember this command
alias erd="erd --human --layout inverted"
alias z="zed"
alias pasta="paste"

set -Ux HOMEBREW_NO_AUTO_UPDATE 1
set -Ux VIMINIT "source ~/.vim/vimrc"
source ~/.config/fish/functions/custom.fish

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

# Set up Pyenv
# https://github.com/pyenv/pyenv#installation
if type -q pyenv
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    # status is-login; and pyenv init --path | source
    pyenv init - | source
end

if type -q es
    es --shell fish init | source
end

# Load additional config based on hostname
set host_config ~/.config/fish/config.(hostname_base).fish
test -r $host_config; and source $host_config

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
