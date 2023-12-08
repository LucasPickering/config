alias j="jira"
alias kdev="k config use-context bzero-developer@development"
alias kprd="k config use-context bzero-developer@production"
alias kstg="k config use-context bzero-developer@staging"
alias kdevconnect="zli connect developer@development --targetGroup developers && kdev"
alias kstgconnect="zli connect developer@staging --targetGroup developers && kstg"
alias kprdconnect="zli connect developer@production --targetGroup developers && kprd"
alias portaldb='mysql --host=$AWS_DB_HOST --user=$AWS_DB_USER --password=$AWS_DB_PASSWORD production'
alias pgdb='PGPASSWORD=$POSTGRES_PASSWORD psql --host=$DB_HOSTNAME --user=$POSTGRES_USER --port=$DB_PORT $POSTGRES_DB'

set -Ux PTVSD 1
set -Ux SKIP_ESLINT_LOADER true

function creds
    # Load AWS creds
    source /opt/homebrew/bin/assume.fish default
    # Use env-select to load more secrets This is ripped from
    # ~/git/portal/dev.sh api creds
    es set aws dev
end

function pgforward --description "Port-forward kube to a postgres service"
    set pg_services (kubectl get service -o name |  grep postgres)
    set service $pg_services[1]
    if test (count $pg_services) -gt 1
        echo "Multiple `postgres` services detected, using the first"
    end
    set external_port 5432
    set internal_port 5433
    set c_normal (set_color normal)
    set c_bold (set_color --bold red)
    echo "Forwarding to $c_bold$service$c_normal"
    kubectl port-forward $service $internal_port:$external_port
end

function docker_login
    set profile $argv[1]
    test -z $profile; and set profile "default"
    aws sso login
    aws --profile $profile ecr get-login-password --region us-east-1 | \
        docker login -u AWS --password-stdin 692674046581.dkr.ecr.us-east-1.amazonaws.com
end

function copy_portal_db
    # Run `docker-compose run --rm db` in a separate window
    cd ~/git/portal
    set db_path $HOME/Downloads/portal-(date +%Y-%m-%d).sql
    es set portal local
    # docker-compose exec db /usr/bin/mysqldump -u$AWS_DB_USER -p$AWS_DB_PASSWORD production > $db_path
    mysql -u$AWS_DB_USER -p$AWS_DB_PASSWORD -e 'DROP DATABASE IF EXISTS production; CREATE DATABASE production;'
    db_path=$db_path mysql -u$AWS_DB_USER -p$AWS_DB_PASSWORD production < $db_path
    echo "Snapshot left at $db_path, delete it!"
end
