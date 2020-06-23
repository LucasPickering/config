# Defined in /usr/local/Cellar/fish/3.1.2/share/fish/functions/fish_prompt.fish @ line 4
function fish_prompt --description 'Write out the prompt'
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix \n'λ '

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

  echo -n -s (set_color red) '['(date "+%H:%M:%S")'] ' (set_color cyan) (pwd) (set_color green) (fish_vcs_prompt) \n (set_color red) '><> ' $normal
end
