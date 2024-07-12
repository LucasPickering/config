# All custom functions can live here. These will be loaded manually
# in config.fish

function git_repo_url --description "Get the HTTP URL of the current repo"
    git ls-remote --get-url origin | sed -E -e 's@git\@([^:]+):(.*)@https://\1/\2@' -e 's@\.git$@@'
end

function github_api_url --description "Get the GitHub API HTTP URL of the current repo"
    git ls-remote --get-url origin | sed -E -e 's@git\@([^:]+):(.*)@https://api.github.com/repos/\2@' -e 's@\.git$@@'
end

function open_pr --description "Open a new PR for this branch on GitHub"
    set repo_url (git_repo_url)
    set src (git rev-parse --abbrev-ref HEAD)

    open "$repo_url/compare/$src?expand=1"
end

function init_branch_description --description "Set the description for a git branch to some default it it's empty"
    set default "\
- Write code
- Write tests
- Prep MR
  - Check all TODOs
  - Check diff
  - Write description
  - Passing tests
- MR
  - Add reviewers
  - Approvals
  - Passing tests
  - Squash
  - Merge
- Log time
- Close ticket"

    set branch (git current)
    set description (git config --get branch.$branch.description | string trim)
    if test -z "$description"
        git config --add branch.$branch.description $default
    end
    git branch --edit-description
end

function checkout_jira --description "Create a new branch with a name based on a ticket"
    set ticket $argv[1]
    # TODO combine these requests
    set key (jira view $ticket --gjq key | string lower)
    # Get the ticket summary, as a list of words
    set summary (jira view $ticket --gjq fields.summary | string lower | string split ' ')
    # Grab the first 3 words from the ticket name
    set branch_name (string join '-' $key $summary[1..3])
    git checkout -b $branch_name
end

function hostname_base --description "Get machine hostname, without extensions"
    # Strip ".home" and ".local" extensions from hostname
    echo (hostname | sed -e "s@\..*\$@@")
end

function kns --description "Get/set kubernetes namespace" -a new_ns
    if test -n "$new_ns"
        # Namespace given - set active context
        kubectl config set-context --current --namespace $new_ns
    else
        # No namespace given - just fetch the namespace/cluster
        set -l context_name (kubectl config current-context 2> /dev/null)
        if test $status != 0
            echo ""
        else
            set -l namespace (kubectl config view --minify -o jsonpath="{.contexts[?(@.name==\"$context_name\")].context.namespace}" 2> /dev/null)
            # Remove BastionZero prefix for BS clusters
            set -l context_short (echo $context_name | sed 's/bzero-.*@//')
            echo "$namespace@$context_short"
        end
    end
end

function kex --description "Execute a command in a kubernetes pod" -a query
    set command $argv[2..-1]
    set -q command or set command "/bin/bash" # TODO this doesn't work
    set podname (kubectl get pod -o custom-columns=:metadata.name --no-headers | grep $query)
    echo "Running `$command` in pod $podname"
    kubectl exec -it $podname -- $command
end

function add_pw --description "Add a new password to the keychain vault thing" -a name -a value
    security add-generic-password -a $LOGNAME -s $name -w $value
end


function get_pw --description "Get a password from the keychain vault thing" -a name
    security find-generic-password -a $LOGNAME -s $name -w
end
