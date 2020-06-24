alias nuke="fd -I node_modules -x rm -rf && yarn install"
alias links="fd -IH -d 1 -t l . node_modules"
alias f="~/git/frontend/dev.sh"
alias p="~/git/portal/dev.sh"
alias y="yarn"

set -Ux SKIP_ESLINT_LOADER true

bass 'source ~/git/infrav3/aliases.sh'
bass 'source <(~/git/portal/dev.sh api creds)'

# TODO make this work
# bass 'eval "$(pyenv init -)"'
# bass 'eval "$(pyenv virtualenv-init -)"'
