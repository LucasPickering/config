alias j="jira"
alias kdev="k config use-context bzero-developer@development"
alias kprd="k config use-context bzero-developer@production"
alias kstg="k config use-context bzero-developer@staging"
alias kdevconnect="zli connect developer@development --targetGroup developers"
alias kstgconnect="zli connect developer@staging --targetGroup developers"
alias kprdconnect="zli connect developer@production --targetGroup developers"
alias portaldb='mysql --host=$AWS_DB_HOST --user=$AWS_DB_USER --password=$AWS_DB_PASSWORD production'

fish_add_path ~/.bskube/bin

set -Ux SKIP_ESLINT_LOADER true

function creds
    # Load AWS creds
    source /usr/local/bin/assume.fish default
    # Load JWT. This is ripped from ~/git/portal/dev.sh api creds
    # We may want to rip the code for DB creds here too (TBD)
    set -gx JWT_SECRET_KEY (aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-east-1:692674046581:secret:cp_jwt_secret_dev-eTk6oj | jq -r '.SecretString | fromjson | .dev_jwt_secret')
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
