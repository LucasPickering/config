alias j="jira"
alias jme="j issue list -q 'assignee = currentUser() AND resolution = unresolved and type != Epic'"
alias jqlog="jq --raw-input 'fromjson? // .'"
alias kdev="k config use-context bzero-developer@development"
alias kdev2="k config use-context bzero-developer@bitsight-development-us-east-1"
alias kstg="k config use-context bzero-developer@staging"
alias kuat="k config use-context bzero-developer@uat"
alias kprd="k config use-context bzero-developer@production"
alias kmini="k config use-context minikube"
alias kdevconnect="zli connect developer@development --targetGroup developers && kdev"
alias kdev2connect="zli connect developer@bitsight-development-us-east-1 --targetGroup developers && kdev2"
alias kstgconnect="zli connect developer@staging --targetGroup developers && kstg"
alias kuatconnect="zli connect developer@uat --targetGroup developers && kuat"
alias kprdconnect="zli connect developer@production --targetGroup developers && kprd"
alias nuke="rm -rf node_modules && yarn install"
alias portaldb='mysql --host=$AWS_DB_HOST --user=$AWS_DB_USER --password=$AWS_DB_PASSWORD --protocol tcp production'
alias pgdb_url='echo "postgresql://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOSTNAME:$DATABASE_PORT/$DATABASE_DB_NAME"'
alias pgdb='PGPASSWORD=$DATABASE_PASSWORD psql --host=$DATABASE_HOSTNAME --user=$DATABASE_USERNAME --port=$DATABASE_PORT $DATABASE_DB_NAME'
alias pgdb_dump='PGPASSWORD=$DATABASE_PASSWORD pg_dump --host=$DATABASE_HOSTNAME --user=$DATABASE_USERNAME --port=$DATABASE_PORT $DATABASE_DB_NAME'
alias pgdb_restore='PGPASSWORD=$DATABASE_PASSWORD pg_restore --host=$DATABASE_HOSTNAME --user=$DATABASE_USERNAME --port=$DATABASE_PORT --dbname=$DATABASE_DB_NAME'
alias assume="source (brew --prefix)/bin/assume.fish"
alias asdf="assume default --export"

# Auto-load AWS creds for actual shells
status --is-interactive; and asdf

set -Ux PTVSD 1
set -Ux SKIP_ESLINT_LOADER true

function pgforward --description "Port-forward kube to a postgres service"
    set pg_services (kubectl get service -o name |  grep postgres)
    set service service/postgresql
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

function helm_login
    set profile $argv[1]
    test -z $profile; and set profile "default"
    aws sso login
    aws --profile $profile ecr get-login-password --region us-east-1 | \
        helm registry login -u AWS --password-stdin 692674046581.dkr.ecr.us-east-1.amazonaws.com
end

function copy_portal_db
    # Run `docker-compose run --rm db` in a separate window
    cd ~/git/portal
    set db_path $HOME/Downloads/portal-(date +%Y-%m-%d).sql
    es set portal local
    docker-compose exec db /usr/bin/mysqldump -u$AWS_DB_USER -p$AWS_DB_PASSWORD production > $db_path
    # This is a disaster and I didn't fix it
    mysql -u$AWS_DB_USER -p$AWS_DB_PASSWORD -e "DROP DATABASE IF EXISTS production; CREATE DATABASE production;"
    db_path=$db_path mysql -u$AWS_DB_USER -p$AWS_DB_PASSWORD production < $db_path
    echo "Snapshot left at $db_path, delete it!"
end

function pgcreate --description "Create new DB and username in postgres"
    set db_name $DATABASE_DB_NAME
    set username $DATABASE_USERNAME
    set password $DATABASE_PASSWORD
    echo "Creating database $db_name with $username:$password"
    # Extra "" needed to escape hyphens
    psql -d postgres -c "CREATE USER \"$username\" WITH CREATEDB PASSWORD '\"$password\"'"
    psql -d postgres -c "CREATE DATABASE \"$db_name\" WITH OWNER \"$username\""
end

function jwt --description "Decode a JWT" -a jwt
    set splits (echo $jwt | string split .)
    set header $splits[1]
    set claims $splits[2]
    echo "Header:" (echo $header | base64 -d)
    echo "Claims:" (echo $claims | base64 -d)
end

function get_secret --description "Get an AWS secret" -a secret
    aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-east-1:692674046581:secret:$secret | jq -r .SecretString
end

function jira_branch --description "Create a new Git branch for a jira ticket" -a ticket
    # If ticket isn't provided, prompt for it
    if test -z $ticket
        set delimiter "::delimiter::"
        set ticket_json (jme --raw \
            | jq -c -r ".[] | \"\\(.key) \\(.fields.summary)$delimiter\\(.)\"" \
            | gum choose --label-delimiter $delimiter --height 100)
        # Abort if prompt was closed
        if test $status -ne 0
            return 1
        end
        set ticket (echo $ticket_json | jq -r '.key')
        set summary (echo $ticket_json | jq -r '.fields.summary')
    end

    # If we didn't just load the summary above, get it now
    if test -z $summary
        set summary (jira issue view $ticket --raw | jq -r '.fields.summary')
    end

    set repo (git root)
    set prompt "Do not perform any actions. Do not return any text other than a
    1-5 word summary of the given text. Exclude stop words and focus on unique
    and distinctive words. Do not include words from the current repo name ($repo)
    The text: $summary"
    set shortened (ai $prompt)
    # Normalize the tag
    set tag (echo $shortened | string lower | string replace -a -r '[^ a-z0-9_-]' '' | string trim | string replace -a ' ' '-')
    # Let the user edit it
    set branch (gum input --header "You like???" --value "$ticket-$tag")
    # Abort if prompt was closed
    if test $status -ne 0
        return 1
    end
    git checkout -b $branch
end

function ai --description "Do something really important with the use of AI™ LLM© Intelligence®" -a prompt
    if test -z $prompt
        set prompt (gum input --header "What the fuck do you want to ask that piece of shit?")
        # Abort if prompt was closed
        if test $status -ne 0
            return 1
        end
    end
    set funny_name_haha "amorphous puddle of floating points" "almighty oracle of goop" "savior of the human race"
    set zany (random choice $funny_name_haha)
    gum spin --title "Asking the $zany..." -- copilot --model claude-sonnet-4 --prompt $prompt
end
