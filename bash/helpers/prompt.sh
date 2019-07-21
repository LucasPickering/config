source "$GITAWAREPROMPT/main.sh"

# Host-specific config
prompt_color=$txtred # Default color
case "$(hostname)" in
    "metagross" | "Lucario" )
        prompt_color=$txtcyn
    ;;
    "salamence" )
        prompt_color=$txtylw
    ;;
    "riolu" )
        prompt_color=$txtpur
    ;;
    "tyranitar" )
        prompt_color=$txtblu
    ;;
esac

# Add docker-machine host
docker_machine=""
if hash __docker_machine_ps1 2>/dev/null; then
    docker_machine='$(__docker_machine_ps1 "\[$txtred\] [%s]")'
fi
git_status="\[$txtgrn\]\$git_branch\$git_dirty"

export PS1="\[$txtred\][\T] \[$prompt_color\]\u@\h:\w$docker_machine $git_status\[$txtrst\]\\n$ "
