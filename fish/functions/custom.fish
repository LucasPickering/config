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

function hostname_base --description "Get machine hostname, without extensions"
    # Strip ".home" and ".local" extensions from hostname
    echo (hostname | sed -e "s@\..*\$@@")
end

function namespace --description 'Get current kube namespace'
    set -l ctx (kubectl config current-context 2> /dev/null)
    if test $status != 0
        echo ""
    else
        kubectl config view 2> /dev/null |\
        grep -A4 " context:" |\
        egrep -A4 "cluster: $ctx\$" |\
        grep namespace |\
        tr -s ' ' |\
        cut -d ' ' -f 3
    end
end

function kns --description "Set kubernetes namespace"
    set -l ctx (kubectl config current-context)
    set -l new_ns $argv[1]
    kubectl config set-context $ctx --namespace $new_ns
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
