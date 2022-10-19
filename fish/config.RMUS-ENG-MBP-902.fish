alias j="jira"

fish_add_path ~/.bskube/bin

function docker_login
    set region "us-east-1"
    aws ecr get-login-password --region "$region" | docker login -u AWS --password-stdin 692674046581.dkr.ecr."$region".amazonaws.com
end
