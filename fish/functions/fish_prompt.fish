function fish_prompt --description 'Write out the prompt'
    set exit_code $status
    set duration $CMD_DURATION
    set -l time $exit_code/(math $duration / 1000)s

    # Color the cwd differently based on host
    set -l host (hostname_base)
    switch $host
        case metagross bulbasaur RMUS-ENG-MBP-1693
            set c_cwd (set_color cyan)
        case riolu piplup squirtle
            set c_cwd (set_color purple)
        case '*'
            set c_cwd (set_color red)
    end

    # If in SSH, always include the hostname
    if set -q SSH_CLIENT
        set -l ctx_host "[$host]"
    end

    set -l cwd (pwd | sed s@^$HOME@~@)
    set -l vcs (string trim (fish_vcs_prompt))

    # Color shortcuts
    set -l c_normal (set_color normal)
    set -l c_vcs (set_color green)
    set -l c_ctx (set_color red)
    set -l c_time (set_color blue)
    set -l c_cmd (set_color blue)

    set -l first_line (string join ' ' $c_ctx$ctx_host $c_time$time $c_cwd$cwd $c_vcs$vcs)
    set -l cmd_line $c_cmd'> '$c_normal

    echo $first_line
    echo -n $cmd_line
end
