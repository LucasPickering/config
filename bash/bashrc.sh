sshmount() {
    # Nick is a shitter
    host=$1
    local_dir=$2
    mkdir -p "$local_dir"
    sshfs -o allow_other,defer_permissions "$host" "$local_dir"
    if [ $? -eq 0 ]; then
        echo "Mounted to $local_dir"
    fi
}

sshumount() {
    local_dir=$1
    umount -f "$local_dir"
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

# OS-based config
case "$(uname)" in
    "Darwin" )
        # export JAVA_TOOL_OPTIONS='-Djava.awt.headless=true' # Prevent Java from appearing in dock
        . $(brew --prefix)/etc/bash_completion # git bash completion

        # The first path here can be obtained from `brew --prefix coreutils`, but that's slow
        # (about 500 ms) so we don't do it every time.
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH" # For brew GNU utils

        alias cdsteam="cd ~/Library/Application\ Support/Steam/Steam.AppBundle/Steam/Contents/MacOS"
        alias copy='pbcopy'
        alias paste='pbpaste'
    ;;
    "Linux" )
        export PATH="$PATH:~/go/bin"

        alias open='xdg-open > /dev/null'
        alias copy='xsel -ib'
        alias paste='xsel -ob'
    ;;
esac

# Add Rust variables
if [ -x "$(command -v rustc)" ]; then
    export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src
fi

# Aliases
alias src="source $BASH_SOURCE"
alias vbp="vim $BASH_SOURCE"
alias ls="ls --color=auto" # Show color
alias grep="grep --color=auto"  # Show color
alias cls="printf '\ec'"
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias potato="ssh pickl@login.ccs.neu.edu"
alias potatomount="sshmount pickl@login.ccs.neu.edu:/home/pickl ccs"

# Env variables
export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ' # Set iTerm2/guake tab names
export HISTCONTROL=ignoreboth:erasedups # Don't put duplicates in history
export HISTSIZE=5000
export HISTFILESIZE=$HISTSIZE
export VIMINIT="source ~/.vim/vimrc"
export GITAWAREPROMPT=~/.bash/git-aware-prompt
. "$GITAWAREPROMPT/main.sh"

# Choose prompt color based on hostname
prompt_color=$txtred # Default color
case "$(hostname)" in
    "metagross" | "Lucario" | "garchomp" )
        prompt_color=$txtcyn
    ;;
    "riolu" )
        prompt_color=$txtpur
    ;;
    "tyranitar" )
        prompt_color=$txtblu
    ;;
esac
export PS1="\[$prompt_color\]\u@\h:\w \[$txtgrn\]\$git_branch\[$txtrst\]\$ "

eval "$(dircolors)" # Populate LS_COLORS variable