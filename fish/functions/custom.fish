# All custom functions can live here. These will be loaded manually
# in config.fish

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

function kns
    set -l ctx (kubectl config current-context)
    set -l new_ns $argv[1]
    kubectl config set-context $ctx --namespace $new_ns
end
