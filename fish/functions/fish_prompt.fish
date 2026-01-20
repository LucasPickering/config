function strip_colors
    echo -n -s (string replace -ra '\e\[[^m]*m' '' $argv[1])
end

# Defined in /usr/local/Cellar/fish/3.1.2/share/fish/functions/fish_prompt.fish @ line 4
function fish_prompt --description 'Write out the prompt'
    # Color the cwd differently based on host
    switch (hostname_base)
        case metagross bulbasaur RMUS-ENG-MBP-1693
            set c_cwd (set_color cyan)
        case riolu piplup squirtle
            set c_cwd (set_color purple)
        case '*'
            set c_cwd (set_color red)
    end

    # cwd
    set -l cwd (pwd | sed s@^$HOME@~@)

    # kube context
    # if type -q kubectl
    #     set -l kube_context (kns)
    #     if test -n $kube_context
    #         set kubectx "[$kube_context]"
    #     end
    # end
    set -l kubectx ""

    set -l dt (date "+%H:%M:%S")
    set -l vcs (string trim (fish_vcs_prompt))

    # Color shortcuts
    set -l c_normal (set_color normal)
    set -l c_vcs (set_color green)
    set -l c_ctx (set_color red)

    set -l first_line (string join ' ' $c_cwd$cwd $c_vcs$vcs)
    set -l second_line (string join ' ' $c_ctx $kubectx $pyctx)
    set -l final_line $c_cwd'õ> '$c_normal

    # If the prompt gets too big to fit on one line, break it into two
    set prompt_len (string length (strip_colors "$first_line $second_line"))
    if test $prompt_len -gt $COLUMNS
        echo -n -s $first_line\n$second_line\n$final_line
    else
        echo -n -s $first_line $second_line\n$final_line
    end
end

function fish_right_prompt
    set exit_code $status
    set duration $CMD_DURATION
    echo -n (set_color brred) $exit_code/(math $duration / 1000)s
end
