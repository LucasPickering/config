repo_url=$(git ls-remote --get-url origin | sed -E 's/git@([^:]+):(.*).git/https:\/\/\1\/\2/')
src=$(git rev-parse --abbrev-ref HEAD)
dest=${1-master}
open "$repo_url/pull-requests/new?source=$src&dest=$dest"
