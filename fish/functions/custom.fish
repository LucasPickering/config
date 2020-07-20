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

function dm-set --description "Set current docker machine"
    set machine $argv[1]
    if test -z $machine
        echo "ERROR: No argument supplied"
        return
    end

    eval (docker-machine env $machine)
    echo "SUCCESS: Set to $machine"
end

function dm-clr --description "Clear current docker machine"
    eval (docker-machine env -u)
    echo "SUCCESS: cleared"
end
