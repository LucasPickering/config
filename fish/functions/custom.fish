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

function kns --description "Get/set kubernetes namespace"
    if set -q argv[1]
        # Namespace given - set active context
        set -l ctx (kubectl config current-context)
        set -l new_ns $argv[1]
        kubectl config set-context $ctx --namespace $new_ns
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

function kex --description "Execute a command in a kubernetes pod" -a q
    set command $argv[2..-1]
    set -q command or set command "/bin/bash"
    set podname (kubectl get pods | awk "/$q/"' {print $1}')
    echo "Running `$command` in pod $podname"
    kubectl exec -it $podname -- $command
end

function wget_sha256 --description "Get the SHA256 sum of a file over HTTP"
    set url $argv[1]
    set path (mktemp)
    wget -q -O $path $url
    set wget_status $status
    if test $wget_status -gt 0
        echo "wget failed with exit code $wget_status"
        return $status
    end
    sha256sum $path
    rm $path
end
