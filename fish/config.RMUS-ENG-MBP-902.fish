alias assume="source /usr/local/bin/assume.fish"
alias creds="bass ./dev.sh api creds | source"
alias j="jira"
alias kdev="zli connect developer@development --targetGroup developers"

fish_add_path ~/.bskube/bin

set -Ux SKIP_ESLINT_LOADER true

function docker_login
    set region $argv[1]
    test -z $region; and set region "us-east-1"
    aws ecr get-login-password --region "$region" |\
        docker login -u AWS --password-stdin 692674046581.dkr.ecr."$region".amazonaws.com
end
