# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  . /usr/share/bash-completion/bash_completion
fi

export PATH="${PATH}:${HOME}/.local/bin"
export PS1="\033[38;5;153m${DOCKER_TAG} \[\033[36m\]\u \[\e[1;37m\]\t \e[1;33m\]\w\[\033[0m\]\n> "
