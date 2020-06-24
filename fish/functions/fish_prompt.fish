# Defined in /usr/local/Cellar/fish/3.1.2/share/fish/functions/fish_prompt.fish @ line 4
function fish_prompt --description 'Write out the prompt'
    set -l normal (set_color normal)

    # Color the prompt differently based on host
    switch (hostname)
        case metagross Lucario
            set color_cwd cyan
        case salamence
            set color_cwd yellow
        case riolu
            set color_cwd purple
        case tyranitar
            set color_cwd blue
    end

    echo -n -s (set_color red) '['(date "+%H:%M:%S")'] ' (set_color $color_cwd) (pwd) (set_color green) (fish_vcs_prompt) \n (set_color red) '><> ' $normal
end
