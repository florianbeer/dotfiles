export PATH=~/bin:/usr/local/git/bin:/usr/local/bin:/usr/local/sbin:/opt/bin:~/.composer/vendor/bin:$PATH

# some settings to be more colorful
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export LESS=-R
export CLICOLOR=true
export LSCOLORS=ExGxFxdxCxDxDxBxBxExEx
export LS_COLORS=ExGxFxdxCxDxDxBxBxExEx

# handy aliases
alias top='top -o cpu'
alias ll='ls -lh'
alias talk='cat - | while read cat; do say $cat; done'
alias devbox='cd ~/Vagrant/devbox/; vagrant ssh'

# no duplicates in bash history
export HISTCONTROL=ignoredups

# export DISPLAY if it's not set yet
[[ -z $DISPLAY ]] && export DISPLAY=":0.0"

# ssh host tab completion
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

function myip {
  res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
  echo "$res"
}

export EDITOR="vim"

# set fancy prompt
if [ -f "$HOME/.bash_ps1" ]; then
    . "$HOME/.bash_ps1"
fi

source /usr/local/git/contrib/completion/git-completion.bash
source /usr/local/git/contrib/completion/git-prompt.sh
source ~/Applications/ansible/hacking/env-setup >& /dev/null

# CWD for tmux
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
