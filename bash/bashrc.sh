# OS-based config
case "$(uname)" in
    "Darwin" )
        # export JAVA_TOOL_OPTIONS='-Djava.awt.headless=true' # Prevent Java from appearing in dock
        # This path can be obtained from `brew --prefix`
        source /usr/local/etc/bash_completion # git bash completion

        # The first path here can be obtained from `brew --prefix coreutils`
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH" # For brew GNU utils

        alias cdsteam="cd ~/Library/Application\ Support/Steam/Steam.AppBundle/Steam/Contents/MacOS"
        alias copy='pbcopy'
        alias paste='pbpaste'
        eval "$(dircolors)" # Populate LS_COLORS variable
    ;;
    "Linux" )
        export PATH="$PATH:~/go/bin:~/.npm/bin"

        alias open='xdg-open > /dev/null'
        alias copy='xsel -ib'
        alias paste='xsel -ob'

        eval $(ssh-agent)
    ;;
esac

case "$(hostname)" in
    "Lucario" )
        export DOCKER_HOST="tcp://salamence:2375"
    ;;
esac

# Env variables
export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ' # Set iTerm2/guake tab names
export HISTCONTROL=ignoreboth:erasedups # Don't put duplicates in history
export HISTSIZE=5000
export HISTFILESIZE=$HISTSIZE
export VIMINIT="source ~/.vim/vimrc"
export GITAWAREPROMPT=~/.bash/git-aware-prompt

# Add Rust variables
if [ -e ~/.cargo ]; then
    export PATH=~/.cargo/bin:$PATH
fi
if [ -x "$(command -v rustc)" ]; then
    export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src
fi

for f in ~/.bash/helpers/*; do source $f; done
