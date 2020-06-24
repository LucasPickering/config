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
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias g="git"
alias d="docker"
alias dc="docker-compose"

if test -d ~/.nvm
    bass 'source ~/.nvm/nvm.sh'
end


switch (uname)
    # Linux-specific setup
    case Linux
        alias copy="xsel -ib"
        alias paste="xsel -ob"


    # Mac-specific setup
    case Darwin
        alias copy="pbcopy"
        alias paste="pbpaste"
end
