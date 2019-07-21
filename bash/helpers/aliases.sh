# Aliases
BASHRC_SRC=~/.bashrc
alias src="source $BASHRC_SRC"
alias vbp="vim $BASHRC_SRC"
alias cbp="code $BASHRC_SRC"
alias ls="ls --color=auto" # Show color
alias grep="grep --color=auto"  # Show color
alias cls="printf '\ec'"
alias pyclean="fd -I __pycache__ -x rm -r; fd -I -e pyc -x rm"
alias potato="ssh pickl@login.ccs.neu.edu"
alias potatomount="sshmount pickl@login.ccs.neu.edu:/home/pickl ccs"
alias purge='sudo apt-get purge $(dpkg -l | grep "^rc" | awk "{print $2}")'
