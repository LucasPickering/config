# echo "$(date +%s%N | cut -b10-13) Start"

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

function cpenv () {
  # Thanks ~Satan~ Yitao
  if [ ! "$(docker ps -q -f name=portal_env)" ]; then
    if [ ! "$(docker ps -aq -f name=portal_env)" ]; then
      docker-compose -f docker-compose-django.yml run --name=portal_env --service-ports portal bash
    else
      docker start -ai portal_env
    fi
  else
    docker exec -ti portal_env bash
  fi
}

function mysqlcreds() {
  # Mysql docker credentials
  scope=$1
  case "$scope" in
    "local")
      secret_id="arn:aws:secretsmanager:us-east-1:692674046581:secret:container_rds_credentials-hLp3Ja"
      rgx=".docker_portal_user, .docker_portal_passwd"
    ;;
    "remote")
      secret_id="arn:aws:secretsmanager:us-east-1:692674046581:secret:cp_rds_credentials-3bM21P"
      rgx=".dev_rds_master_user, .dev_rds_master_pass"
    ;;
    *)
      echo "Invalid scope"
      return 1
    ;;
  esac
  mysql_creds=`aws secretsmanager get-secret-value --secret-id ${secret_id}`
  read -d "\n" USER PASSWORD <<< $(echo $mysql_creds | jq -r '.SecretString' | jq -r "$rgx")
  echo "User: $USER; Password: $PASSWORD"
  export AWS_DB_USER=$USER
  export AWS_DB_PASSWORD=$PASSWORD
}

bspep8() {
  (git diff -w master | pycodestyle --diff --max-line-length=100 | grep -v migrations $@);
}

function repeat() {
  i=1
  while true; do
    echo ""
    echo "===== RUN $i ====="
    eval $@ || break
    i=$((i+1))
  done
}

# Aliases
alias copy='pbcopy'
alias paste='pbpaste'
alias src="source $BASH_SOURCE"
alias vbp="vim $BASH_SOURCE"
alias cbp="code $BASH_SOURCE"
alias ls="ls --color=auto" # Show color
alias grep="grep --color=auto"  # Show color
alias cls="printf '\ec'"
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias nuke="rm -rf node_modules/ && yarn install"
alias dcd="docker-compose -f docker-compose-django.yml"
alias links="fd -IH -d 1 -t l . node_modules"

# Env variables
# The first path here can be obtained from `brew --prefix coreutils`, but that's slow
# (about 500 ms) so we don't do it every time.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:~/.bskube/bin:$PATH"
export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ' # Set iTerm2/guake tab names
export HISTCONTROL=ignoreboth:erasedups # Don't put duplicates in history
export HISTSIZE=5000
export HISTFILESIZE=$HISTSIZE
export VIMINIT="source ~/.vim/vimrc"
export GITAWAREPROMPT=~/.bash/git-aware-prompt

eval "$(dircolors)" # Populate LS_COLORS variable

# Load AWS creds
source <(grep = ~/.aws/credentials | sed 's/ *= */=/g')
export PORTAL_ACCESS_KEY=$aws_access_key_id
export PORTAL_SECRET_KEY=$aws_secret_access_key

source $(brew --prefix)/etc/bash_completion # git bash completion
source "$GITAWAREPROMPT/main.sh"
# source "$HOME/git/infrav3/aliases.sh"
source ~/.nvm/nvm.sh

git_status="\[$txtgrn\]\$git_branch\$git_dirty"
export PS1="\[$txtred\][\T] \[$txtcyn\]\w $git_status\[$txtrst\]\n\$ "
