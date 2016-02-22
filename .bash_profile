# ----------------------------------------------------------------------------
# SHELL OPTIONS
# ----------------------------------------------------------------------------

# bring in system bashrc
if [ -r /etc/bashrc ]; then
    . /etc/bashrc
fi

# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
shopt -s extglob                 >/dev/null 2>&1
shopt -s histappend              >/dev/null 2>&1
shopt -s hostcomplete            >/dev/null 2>&1

# default umask
umask 0022

# ----------------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------------

CDPATH=.:$HOME/Sites

# we want the various sbins on the path along with /usr/local/bin
PATH="/usr/local/sbin:/usr/sbin:$PATH"

PATH="$PATH:$HOME/.composer/vendor/bin"

# put ~/bin first on PATH
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# ----------------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------------

# enable en_US locale w/ utf-8 encodings if not already configured
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# history stuff
HISTCONTROL=ignoreboth
if [ "$(uname)" != "Darwin" ]; then
  HISTFILESIZE=100000
  HISTSIZE=100000
fi

# this is important!
EDITOR=vim
export EDITOR

# pager
if [ -n "$(command -v less)" ]; then
    PAGER="less -FirSw"
    MANPAGER="less -FiRsw"
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# ----------------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------------

# git prompt options
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true

# root is red
if [ $(id -u) -eq 0 ]; then
  COL=1
else
  COL=24
fi

PS1='\[$(tput setaf ${COL})\]\h: \W\[$(tput setaf 3)\]$(__git_ps1 " (%s)")\[$(tput setaf ${COL})\] \342\226\270 \[$(tput sgr0)\]'

# CWD for tmux
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

# ----------------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------------

# use brew bash-completion when on OS X otherwhise use linux variant
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion;
fi;

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
fi

# ----------------------------------------------------------------------
# COLORS
# ----------------------------------------------------------------------

# color grep and less
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export LESS=-R

# Detect which 'ls' flavor is in use
if ls --color > /dev/null 2>&1; then # GNU 'ls'
  colorflag="--color"
else # OS X 'ls'
  colorflag="-G"
fi

# List files colorized in long format
alias ll="ls -lh ${colorflag}"

# List all files colorized
alias la="ls -lah ${colorflag}"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;37m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# grc
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ] 
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure' 
        for app in {diff,make,gcc,g++,mtr,traceroute,netstat,traceroute,head,tail,dig,mount,ps,mtr,df}; do
            alias "$app"='colourify '$app
        done
fi

# ----------------------------------------------------------------------------
# FUNCTIONS
# ----------------------------------------------------------------------------

# display external IP address
myip() {
  echo $(dig +short myip.opendns.com @resolver1.opendns.com)
}

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

# ----------------------------------------------------------------------------
# OS X SPECIFIC STUFF
# ----------------------------------------------------------------------------

if [ "$(uname)" == "Darwin" ]; then

  # check if host is up and announce through text-to-speech
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

  # Homestead helper
  function vm() {
    cd ~/Homestead

    command="$1"

    if [ "$command" = "edit" ]; then
      open ~/.homestead/homestead.yaml
    else
      if [ -z "$command" ]; then 
        command="ssh"
      fi

      eval "vagrant ${command}"
    fi

    cd -
  }

fi

ulimit -n 2560
