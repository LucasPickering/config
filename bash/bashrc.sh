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

mysqlcreds() {
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
    "prd")
      secret_id="arn:aws:secretsmanager:us-east-1:692674046581:secret:cp_rds_credentials-3bM21P"
      rgx=".portal_user, .prod_portal_pass"
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

# repeat() {
#   i=1
#   while true; do
#     echo "===== RUN $i ($(date)) ====="
#     eval $@ || break
#     echo ""
#     i=$((i+1))
#   done
# }

deploy() {
  target=$1
  if [ -z "$target" ]; then
    echo "Deploying to $(namespace)"
    args=(proxy)
  else
    echo "Deploying to EC2 node $target"
    args="ec2 cp101.$target.ame1.bitsighttech.com"
  fi
  ./dev.sh manifest $args | bskube manifest run
}

proxy() {
  target=$1
  file="proxy.config.json"

  if [ -z "$target" ]; then
    cat "$file"
    return 0
  elif [ "$target" == "local" ]; then
    url="http://local.bitsighttech.com:8000"
  else
    url="https://cp101.$target.ame1.bitsighttech.com"
  fi
  echo "URL: $url"

  sed -E -i '' 's@"target": .*$@"target": "'"$url"'",@' "$file"
  cat "$file"
  echo "Wrote to $file"
}

verify_bsc() {
  version=$1
  tag="bs-components@$version"
  branch=verify-bs-components-$version

  if [ -z "$version" ]; then
    echo "No version specified"
    return 1
  fi

  set -x
  echo "Running tests for $tag"
  git stash push -m "Stash before bs-components verification"
  git checkout develop
  git pull
  (git checkout -b $branch || git checkout $branch)
  yarn upgrade $tag
  git commit -am "Upgrade to $tag for verification"
  git push -u origin $branch
  yarn test:remote
  set +x
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
alias repeat="~/config/bash/repeat.py"
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias nuke="rm -rf node_modules/ && yarn install"
alias links="fd -IH -d 1 -t l . node_modules"
alias g="git"
alias d="docker"
alias y="yarn"
complete -F _git g
complete -F _docker d
complete -F _yarn y

# Env variables
# The first path here can be obtained from `brew --prefix coreutils`, but that's slow
# (about 500 ms) so we don't do it every time.
export GOPATH="$HOME/.go"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$HOME/.bskube/bin:$GOPATH/bin:$PATH"
# export GOPATH="~/.go"
export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ' # Set iTerm2/guake tab names
export HISTCONTROL=ignoreboth:erasedups # Don't put duplicates in history
export HISTSIZE=5000
export HISTFILESIZE=$HISTSIZE
export VIMINIT="source ~/.vim/vimrc"
export GIT_COMPLETION_CHECKOUT_NO_GUESS=1 # Don't tab-complete remote branches
export GITAWAREPROMPT=~/.bash/git-aware-prompt
export PORTAL_BASE=~/git/portal/cust-portal/app

eval "$(dircolors)" # Populate LS_COLORS variable
eval "$(jira --completion-script-bash)"

# Load AWS creds
source <(grep = ~/.aws/credentials | sed 's/ *= */=/g')
export PORTAL_ACCESS_KEY=$aws_access_key_id
export PORTAL_SECRET_KEY=$aws_secret_access_key

source $(brew --prefix)/etc/bash_completion # git bash completion
source "$GITAWAREPROMPT/main.sh"
source ~/git/infrav3/aliases.sh
source ~/.nvm/nvm.sh

kube_status="\[$txtblu\](\$(namespace)@\$(kubectl config current-context))"
git_status="\[$txtgrn\]\$git_branch\$git_dirty"
export PS1="\[$txtred\][\T] \[$txtcyn\]\w $kube_status $git_status \[$txtrst\]\nλ "
