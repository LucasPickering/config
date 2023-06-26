alias j="jira"
alias kdev="k config use-context bzero-developer@development"
alias kprd="k config use-context bzero-developer@production"
alias kstg="k config use-context bzero-developer@staging"
alias kdevconnect="zli connect developer@development --targetGroup developers && kdev"
alias kstgconnect="zli connect developer@staging --targetGroup developers && kstg"
alias kprdconnect="zli connect developer@production --targetGroup developers && kprd"
alias portaldb='mysql --host=$AWS_DB_HOST --user=$AWS_DB_USER --password=$AWS_DB_PASSWORD production'

set -Ux PTVSD 1
set -Ux SKIP_ESLINT_LOADER true

function creds
    # Load AWS creds
    source /usr/local/bin/assume.fish default
    # Use env-select to load more secrets This is ripped from
    # ~/git/portal/dev.sh api creds
    es aws dev | source
end

function ess
    set output (es $argv)
    if test $status -eq 0
        echo $output | source
    else
        echo "sad"
    end
end

function pgforward --description "Port-forward kube to a postgres pod"
    set pg_pods (kubectl get pod -o name | sed 's@pod/@@' | grep postgres)
    set pod $pg_pods[1]
    if test (count $pg_pods) -gt 1
        echo "Multiple `postgres` pods detected, using the first"
    end
    set external_port 5432
    set internal_port 5433
    set c_normal (set_color normal)
    set c_bold (set_color --bold red)
    echo "Forwarding to pod $c_bold$pod$c_normal"
    kubectl port-forward $pod $internal_port:$external_port
end

function docker_login
    set profile $argv[1]
    test -z $profile; and set profile "default"
    aws sso login
    aws --profile $profile ecr get-login-password --region us-east-1 | \
        docker login -u AWS --password-stdin 692674046581.dkr.ecr.us-east-1.amazonaws.com
end
