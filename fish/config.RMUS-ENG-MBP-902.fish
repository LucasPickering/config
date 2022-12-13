alias j="jira"
alias kdev="zli connect developer@development --targetGroup developers"
alias kstg="zli connect developer@staging --targetGroup developers"
alias kprd="zli connect developer@production --targetGroup developers"
alias portaldb='mysql --host=$AWS_DB_HOST --user=$AWS_DB_USER --password=$AWS_DB_PASSWORD production'

fish_add_path ~/.bskube/bin

set -Ux SKIP_ESLINT_LOADER true

function creds
    # Load AWS creds
    source /usr/local/bin/assume.fish
    # Load the JWT from AWS. We *don't* want everything from this command
    # because it overrides the AWS keys we got before.
    # We *may* want to pull in the DB creds here too, that's TBD
    ~/git/portal/dev.sh api creds | rg JWT | source
end

function pgforward --description "Port-forward kube to a postgres pod"
    set pod_name (kubectl get pod -o name | sed 's@pod/@@' | grep postgres)
    set external_port 5432
    set internal_port 5433
    set c_normal (set_color normal)
    set c_bold (set_color --bold red)
    echo "Forwarding to pod $c_bold$pod_name$c_normal"
    kubectl port-forward $pod_name $internal_port:$external_port
end

function docker_login
    set region $argv[1]
    test -z $region; and set region "us-east-1"
    aws ecr get-login-password --region "$region" |\
        docker login -u AWS --password-stdin 692674046581.dkr.ecr."$region".amazonaws.com
end
