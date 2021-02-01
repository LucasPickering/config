alias j="jira"
alias gomp="python ~/MarkForged/Toolbox/etc/gomp.py"
alias mfc="node ~/MarkForged/mf-cli/src/mf-cli.js"
alias nw="/Applications/nwjs.app/Contents/MacOS/nwjs"

set -Ux NPM_TOKEN (cat ~/.npmtoken)

function mfdev
    bass source $MF_ROOT/Toolbox/etc/dev.sh ';' mfdev $argv
end
