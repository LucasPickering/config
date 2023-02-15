# All custom functions can live here. These will be loaded manually
# in config.fish

function export_colors --description 'Export color scheme to a file'
    set dest "$HOME/.config/fish/conf.d/colors.fish"
    echo "#!/usr/bin/env fish" > $dest
    echo "" >> $dest
    chmod +x $dest

    for i in (set -n | string match 'fish*_color*')
        echo "set $i $$i" >> $dest
    end

    echo "Fish colors have been set" >> $dest

    echo Exported your colors to (set_color cyan --underline)$dest(set_color normal)
    echo "Now, just copy that file to your remote machine and run it."
end

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
            set -l namespace (kubectl config view --minify -o jsonpath="{.contexts[?(@.name==\"$context_name\")].context.namespace}")
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

function dotenv --description "Load environment variables from .env file"
  set -l envfile ".env"
  if [ (count $argv) -gt 0 ]
    set envfile $argv[1]
  end

  if test -e $envfile
    for line in (cat $envfile)
      set -xg (echo $line | cut -d = -f 1) (echo $line | cut -d = -f 2-)
    end
  end
end


function dm_set --description "Set current docker machine"
    set machine $argv[1]
    if test -z $machine
        echo "ERROR: No argument supplied"
        return
    end

    eval (docker-machine env $machine)
    echo "SUCCESS: Set to $machine"
end

function dm_clr --description "Clear current docker machine"
    eval (docker-machine env -u)
    echo "SUCCESS: cleared"
end

function gibberish --description "Replace some bytes in a string with gibberish"
    read -d '' -z lines
    set gibberish '$' '¥' '&' 'Ķ' 'æ'

    for char in (string split '' $lines)
        if test $char != "\n" -a (random 0 10) = 0
            echo -n (random choice $gibberish)
        else
            echo -n $char
        end
    end
end

function setup_lorri
    lorri init
    direnv allow
end

function dotenv
  for i in (cat $argv)
    set arr (echo $i |tr = \n)
      set -gx $arr[1] $arr[2]
  end
end
