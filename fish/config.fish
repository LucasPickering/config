alias copy='pbcopy'
alias paste='pbpaste'
alias src="source ~/.config/fish/config.fish"
alias ls="ls --color=auto" # Show color
alias grep="grep --color=auto"  # Show color
alias cls="printf '\ec'"
alias repeat="~/config/bash/repeat.py"
alias creds="bass 'source <(~/git/portal/dev.sh api creds)'"
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias nuke="fd -I node_modules -x rm -rf && yarn install"
alias links="fd -IH -d 1 -t l . node_modules"
alias p="~/git/portal/dev.sh"
alias f="~/git/frontend/dev.sh"
alias g="git"
alias d="docker"
alias dc="docker-compose"
alias y="yarn"

bass 'source ~/.nvm/nvm.sh'
# bass 'source ~/git/infrav3/aliases.sh'
bass 'eval "$(pyenv init -)"'
bass 'eval "$(pyenv virtualenv-init -)"'
