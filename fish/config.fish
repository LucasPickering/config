# Install fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

alias src="source ~/.config/fish/config.fish"
alias ls="ls --color=auto" # Show color
alias grep="grep --color=auto"  # Show color
alias cls="printf '\ec'"
alias repeat="~/.config/fish/functions/repeat.py"
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias d="docker"
alias dc="docker-compose"
alias g="git"
alias k="kubectl"

set -Ux VIMINIT "source ~/.vim/vimrc"

# Load NVM if present
if test -d ~/.nvm
    bass 'source ~/.nvm/nvm.sh'
end


# OS-specific setup
switch (uname)
    case Linux
        alias copy="xsel -ib"
        alias paste="xsel -ob"

    case Darwin
        alias copy="pbcopy"
        alias paste="pbpaste"
end

# Load additional config based on hostname
set host_config ~/.config/fish/config.(hostname).fish
test -r $host_config; and source $host_config
