alias nuke="fd -I node_modules -x rm -rf && yarn install"
alias links="fd -IH -d 1 -t l . node_modules"
alias creds="bass 'source <(~/git/portal/dev.sh api creds)'"
alias f="~/git/frontend/dev.sh"
alias p="~/git/portal/dev.sh"
alias y="yarn"

set -Ux SKIP_ESLINT_LOADER true
set -Ux PYENV_VIRTUALENV_DISABLE_PROMPT 1

# Load pyenv
status --is-interactive; and pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

bass 'source ~/git/infrav3/aliases.sh'

# function mysqlcreds
#     set scope $argv[0]

#     switch "$scope"
#         case local
#             set secret_id "arn:aws:secretsmanager:us-east-1:692674046581:secret:container_rds_credentials-hLp3Ja"
#             set rgx ".docker_portal_user, .docker_portal_passwd"
#         case remote
#             set secret_id "arn:aws:secretsmanager:us-east-1:692674046581:secret:cp_rds_credentials-3bM21P"
#             set rgx ".dev_rds_master_user, .dev_rds_master_pass"
#         case prd
#             set secret_id "arn:aws:secretsmanager:us-east-1:692674046581:secret:cp_rds_credentials-3bM21P"
#             set rgx ".portal_user, .prod_portal_pass"
#         case '*'
#             echo "Invalid scope"
#             return 1
#     end

#     mysql_creds (aws secretsmanager get-secret-value --secret-id $secret_id)
#     read -d "\n" USER PASSWORD < (echo $mysql_creds | jq -r '.SecretString' | jq -r "$rgx")
#     echo "User: $USER; Password: $PASSWORD"
#     export AWS_DB_USER=$USER
#     export AWS_DB_PASSWORD=$PASSWORD
# end
