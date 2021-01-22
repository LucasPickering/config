# Install fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end


alias src="source ~/.config/fish/config.fish"
alias grep="grep --color=auto"  # Show color
alias cls="printf '\ec'"
alias repeat="~/.config/fish/functions/repeat.py"
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias nuke="rm -rf node_modules && npm install"
alias c="cargo"
alias d="docker"
alias dc="docker-compose"
alias g="git"
alias k="kubectl"

set -Ux VIMINIT "source ~/.vim/vimrc"
source ~/.config/fish/functions/custom.fish

# OS-specific setup
switch (uname)
    case Linux
        alias copy="xsel -ib"
        alias paste="xsel -ob"

        set -Ux GPG_TTY (tty)

    case Darwin
        alias copy="pbcopy"
        alias paste="pbpaste"
        set PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
end

if test -d ~/.cargo
    set PATH $HOME/.cargo/bin $PATH
end

# Get directory of this script, for usage later
# This has to go AFTER overriding PATH with our coreutils version (for Mac)
set FISH_DIR (dirname (readlink -m (status --current-filename)))

# Set up Pyenv
set -Ux PYENV_ROOT $FISH_DIR/pyenv
set PATH $PYENV_ROOT/bin $PATH
set -Ux PYENV_VIRTUALENV_DISABLE_PROMPT 1
# Install pyenv-virtualenv if it isn't already
pyenv virtualenv --help 2>&1 > /dev/null
if test $status -ne 0
    echo "Installing pyenv-virtualenv"
    git clone https://github.com/pyenv/pyenv-virtualenv.git (pyenv root)/plugins/pyenv-virtualenv
end
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

# Load additional config based on hostname
set host_config ~/.config/fish/config.(hostname).fish
test -r $host_config; and source $host_config
