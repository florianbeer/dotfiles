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

  # OS X specific aliases
  alias top='top -o cpu'
  alias talk='cat - | while read cat; do say $cat; done'
fi

# bash prompt
if [ $(id -u) -eq 0 ]; then
  COL=1
else
  COL=2
fi
PS1='\[$(tput setaf ${COL})\]\h: \W\[$(tput setaf 3)\]$(__git_ps1 " (%s)")\[$(tput setaf ${COL})\] \342\226\270 \[$(tput sgr0)\]'

# some settings to be more colorful
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export LESS=-R

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

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

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
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

