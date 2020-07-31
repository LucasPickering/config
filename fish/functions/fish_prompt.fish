function strip_colors
    echo -n -s (string replace -ra '\e\[[^m]*m' '' $argv[1])
end

# Defined in /usr/local/Cellar/fish/3.1.2/share/fish/functions/fish_prompt.fish @ line 4
function fish_prompt --description 'Write out the prompt'
    # Color the cwd differently based on host
    switch (hostname)
        case metagross Lucario BOS-ENG-MBP-1076
            set c_cwd (set_color cyan)
        case salamence
            set c_cwd (set_color yellow)
        case riolu
            set c_cwd (set_color purple)
        case tyranitar
            set c_cwd (set_color blue)
        case '*'
            set c_cwd (set_color red)
    end

    # cwd
    set -l cwd (pwd | sed s@^$HOME@~@)

    # docker-machine context
    if test -n "$DOCKER_MACHINE_NAME"
        set dockermachinectx "[$DOCKER_MACHINE_NAME]"
    end

    # kube context
    set -l kns (namespace)
    if test -n $kns
        set -l cluster (kubectl config current-context)
        set kubectx "[$kns@$cluster]"
    end

    # pyenv context
    if set -q PYENV_VIRTUAL_ENV
        set -l pv (basename $PYENV_VIRTUAL_ENV)
        set pyctx "[$pv]"
    end

    set -l dt (date "+%H:%M:%S")
    set -l vcs (fish_vcs_prompt)

    # Color shortcuts
    set -l c_normal (set_color normal)
    set -l c_dt (set_color brred)
    set -l c_vcs (set_color green)
    set -l c_ctx (set_color red)

    set -l first_line $c_dt "$dt " $c_cwd $cwd $c_vcs $vcs
    set -l second_line $c_ctx "$dockermachinectx $kubectx $pyctx"
    set -l final_line $c_normal '><> '

    # If the prompt gets too big to fit on one line, break it into two
    set prompt_len (string length (strip_colors "$first_line $second_line"))
    set term_width (tput cols)
    if test $prompt_len -gt $term_width
        echo -n -s $first_line \n $second_line \n $final_line
    else
        echo -n -s $first_line $second_line \n $final_line
    end
end
