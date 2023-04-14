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
    # Load JWT. This is ripped from ~/git/portal/dev.sh api creds
    # We may want to rip the code for DB creds here too (TBD)
    set -gx JWT_SECRET_KEY (aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-east-1:692674046581:secret:cp_jwt_secret_dev-eTk6oj | jq -r '.SecretString | fromjson | .dev_jwt_secret')
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
    aws --profile $profile ecr get-login-password --region us-east-1 | \
        docker login -u AWS --password-stdin 692674046581.dkr.ecr.us-east-1.amazonaws.com
end
