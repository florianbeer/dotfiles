if [ "$(uname)" == "Darwin" ]; then

  # display git status on prompt
  if [[ -f /usr/local/git/contrib/completion/git-completion.bash && -f /usr/local/git/contrib/completion/git-prompt.sh ]]; then
    source /usr/local/git/contrib/completion/git-completion.bash
    source /usr/local/git/contrib/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWCOLORHINTS=true
  fi

  # Ansible
  if [[ -f ~/Applications/ansible/hacking/env-setup ]]; then
    source ~/Applications/ansible/hacking/env-setup >& /dev/null
  fi

  # Path
  export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/opt/bin:$PATH

  # check if host is up
  hostup() {
      if (( $# != 1 )); then
          echo "Usage: hostup HOSTNAME"
      else
          until $(which ping) -W1 -c1 ${1} > /dev/null; do sleep 5; done && $(which say) "${1} is up"
      fi
  }

  # aliases
  export CLICOLOR=true
  export LSCOLORS=ExGxFxdxCxDxDxBxBxExEx
  alias ll='ls -lh'
  alias la='ls -lhA'
  alias top='top -o cpu'
  alias talk='cat - | while read cat; do say $cat; done'

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

  # aliases
  LS_COLORS=$(eval `dircolors`)
  export LS_COLORS
  alias ll='ls -lh --color=auto'
  alias la='ls -lhA --color=auto'
  
fi

# bash prompt
if [ $(id -u) -eq 0 ]; then
  COL=1
  PRMPT=\342\230\240
else
  COL=2
  PRMPT=\342\226\270
fi
PS1='\[$(tput setaf ${COL})\]\h: \W\[$(tput setaf 3)\]$(__git_ps1 " (%s)")\[$(tput setaf ${COL})\] ${PRMPT} \[$(tput sgr0)\]'

# some settings to be more colorful
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export LESS=-R

#man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;37m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# set some defaults
export LC_ALL='en_US.UTF-8'
export HISTCONTROL=ignoredups
export HISTSIZE=10000
export EDITOR=vim

# ssh host tab completion
if [[ -f ~/.ssh/known_hosts ]]; then
  complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
fi

# display external IP address
myip() {
  echo $(dig +short myip.opendns.com @resolver1.opendns.com)
}

# CWD for tmux
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

# set tmux pane title to short hostname on ssh
ssh() {
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
      tmux rename-window "$(echo $* | cut -d . -f 1)"
      command ssh "$@"
      tmux set-window-option automatic-rename "on" 1>/dev/null
    else
      command ssh "$@"
    fi
}
