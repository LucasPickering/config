sshmount() {
    # Nick is a shitter
    host=$1
    local_dir=$2
    mkdir -p "$local_dir"

    opts=allow_other
    case "$(uname)" in
        "Darwin" )
            opts=$opts,defer_permissions
        ;;
    esac
    sshfs -o $opts "$host" "$local_dir"
    if [ $? -eq 0 ]; then
        echo "Mounted to $local_dir"
    fi
}

sshumount() {
    local_dir=$1
    case "$(uname)" in
        "Darwin" )
            umount -f "$local_dir"
        ;;
        "Linux" )
            fusermount -u "$local_dir"
        ;;
    esac
    if [ $? -eq 0 ]; then
        echo "Unmounted $local_dir"
        rmdir "$local_dir"
    fi
}

checksum() {
    if $($1 $2 | grep -iq "\b$3\b"); then
        echo "${txtgrn}GOOD${txtrst}"
    else
        echo "${txtred}BAD${txtrst}"
    fi
}

mkpy() {
    mkdir -p $1
    touch $1/__init__.py
}

# https://gist.github.com/inooid/e0a6152d36676b765535
dm-set () {
  if [ -z "$1" ] ; then
    echo "${txtred}ERROR:${txtrst} no argument supplied"
    return;
  fi

  eval "$(docker-machine env $1)"
  echo "${txtgrn}SUCCESS:${txtrst} set to $1"
}

dm-clr () {
  eval "$(docker-machine env -u)"
  echo "${txtgrn}SUCCESS:${txtrst} cleared"
}
