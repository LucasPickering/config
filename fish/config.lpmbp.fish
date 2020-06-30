alias nuke="fd -I node_modules -x rm -rf && yarn install"
alias links="fd -IH -d 1 -t l . node_modules"
alias creds="bass 'source <(~/git/portal/dev.sh api creds)'"
alias f="~/git/frontend/dev.sh"
alias p="~/git/portal/dev.sh"
alias y="yarn"

set -Ux SKIP_ESLINT_LOADER true
set -Ux PYENV_VIRTUALENV_DISABLE_PROMPT 1
set -Ux GIT_COMPLETION_CHECKOUT_NO_GUESS 1 # Don't tab-complete remote branches

# Load pyenv
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

bass 'source ~/git/infrav3/aliases.sh'
