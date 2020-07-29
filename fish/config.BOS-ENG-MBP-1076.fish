alias nuke="fd -I node_modules -x rm -rf && yarn install"
alias links="fd -IH -d 1 -t l . node_modules"
alias creds="bass 'source <(~/git/portal/dev.sh api creds)'"
alias f="~/git/frontend/dev.sh"
alias j="jira"
alias p="~/git/portal/dev.sh"
alias y="yarn"

set -Ux SKIP_ESLINT_LOADER true
set -Ux PYENV_VIRTUALENV_DISABLE_PROMPT 1

# Load pyenv
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

bass 'source ~/git/infrav3/aliases.sh'

function open_pr --description "Open a new PR for this branch on Bitbucket"
    set repo_url (git ls-remote --get-url origin | sed -E 's@git\@([^:]+):(.*)@https://\1/\2@')
    set src (git rev-parse --abbrev-ref HEAD)

    # Read dest from arg, fall back to repo's default branch
    set dest $argv[1]
    if test -z $dest
        set dest (git default)
    end

    open "$repo_url/pull-requests/new?source=$src&dest=$dest"
end

function docker_login
    set region $argv[1]
    test -z $region; and set region "us-east-1"
    aws ecr get-login-password --region "$region" |\
        docker login -u AWS --password-stdin 692674046581.dkr.ecr."$region".amazonaws.com
end

function verify_bsc
    set bsc_version $argv[1]
    set tag "bs-components@$bsc_version"
    set branch "verify-bs-components-$bsc_version"

    if test -z "$bsc_version"
        echo "No version specified"
        return 1
    end

    echo "Running tests for $tag"
    git stash push -m "Stash before bs-components verification"
    git checkout develop
    git pull
    git checkout -b $branch || git checkout $branch
    yarn upgrade $tag
    git commit -am "Upgrade to $tag for verification"
    git push -u origin $branch
    yarn test:remote
end
