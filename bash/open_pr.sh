repo_url=$(git ls-remote --get-url origin | sed -E 's@git\@([^:]+):(.*)@https://\1/\2@')
src=$(git rev-parse --abbrev-ref HEAD)
dest=${1-$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')}
open "$repo_url/pull-requests/new?source=$src&dest=$dest"
