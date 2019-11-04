# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# check https://github.com/mrzool/bash-sensible/blob/master/sensible.bash
# for some sensible defaults

# Disable ctrl-s causing scroll lock
# https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set PATH so it includes stuff from .local/bin (python stuff etc)
if [ -d "$HOME/.local/bin" ]; then
	if [[ $PATH != *".local/bin"* ]]; then
		PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
	fi
fi
export PATH

# don't put duplicate lines or lines starting with space in the history.
# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# default bg,fg
db='\[\e[49m\]'
df='\[\e[39m\]'

# choose host color based on hash of hostname
# we cherrypick a basic palette of reasonable colours
cherrypkd_colors=(7 75 113 183 42 248 130)
colour_index=$((`hostname | cksum | cut -d ' ' -f 1` % ${#cherrypkd_colors[@]}))
HOST_COLOUR=${cherrypkd_colors[colour_index]}
# HOST_COLOUR=75
OTHER_COLOUR=236
# black-fg white-bg
bf="\[\e[38;5;${OTHER_COLOUR}m\e[48;5;${HOST_COLOUR}m\]"

# black-bg host_colour-fg
bb="\[\e[48;5;${OTHER_COLOUR}m\e[38;5;${HOST_COLOUR}m\]"
blue="\[\e[38;5;32m\]"
red="\[\e[38;5;210m\]"
purple="\[\e[38;5;129m\]"
orange="\[\e[38;5;214m\]"
yellow="\[\e[38;5;220m\]"
maroon="\[\e[38;5;52m\]"
green="\[\e[38;5;34m\]"

# Separator used
sep=""

function prompt_command {
	two_par_folders="$(pwd | rev | cut -d'/' -f 1,2 | rev)"
	# append each command to the history
	history -a
	# build the prompt from parts
	prompt_parts=()
	# Virtual environment info
	if [[ "$VIRTUAL_ENV" != "" ]]
	then
		venv_path=$(dirname $VIRTUAL_ENV)
		if [[ "$PWD" == "$venv_path"* ]]
		then
			venv_section="$blue"
		else
			venv_section="$yellow"
		fi
		prompt_parts+=("$venv_section")
	fi
	# Git stuff
	git_untracked=`git status --untracked-files=no --porcelain ${pwd} 2>/dev/null`
	if [[ $? == 0 ]]
	then
		branch=`git branch ${pwd} | grep '^* ' | cut -d ' ' -f 2` 
		if [[ -z "${branch// }" ]]
		then
			branch_sec=" new repo "
		else
			branch_sec=" $branch "
		fi
		num_modified=`echo "$git_untracked" | grep '[ M]M ' | wc -l`
		if [[ $num_modified != 0 ]]
		then
			mod_sec="$orange$num_modified  $df"
		else
			mod_sec=""
		fi
		num_add=`echo "$git_untracked" | grep '^M ' | wc -l`
		if [[ $num_add != 0 ]]
		then
			add_sec="$green$num_add  $df"
		else
			add_sec=""
		fi
		num_del=`echo "$git_untracked" | grep '^D[ D] ' | wc -l`
		if [[ $num_del != 0 ]]
		then
			del_sec="$red$num_del  $df"
		else
			del_sec=""
		fi
		num_stash=`git stash list ${pwd} | wc -l`
		if [[ $num_stash != 0 ]]
		then
			stash_sec="$maroon$num_stash  $df"
		else
			stash_sec=""
		fi
		git_section="$branch_sec$mod_sec$add_sec$del_sec$stash_sec"
		prompt_parts+=("$git_section")
	fi
	# Set PS1 with path truncated to two folders
	path_section="  $two_par_folders"

	prompt_parts+=("$path_section")

	counter=0
	PS1=""
	num_prompts=${#prompt_parts[@]}
	for part in "${prompt_parts[@]}"
	do
		counter=$((counter + 1))
		modulo=$(($counter % 2 ))
		if [[ $modulo == 0 ]]
		then
			if [[ $counter == $num_prompts ]]
			then
				PS1="$PS1$bf $part $bb$db$sep $df "
			else
				PS1="$PS1$bf $part $bb$sep "
			fi
		else
			if [[ $counter == $num_prompts ]]
			then
				PS1="$PS1$bb $part $bf$db$sep $df "
			else
				PS1="$PS1$bb $part $bf$sep "
			fi
		fi
	done
	PS1="$PS1\n"
	export PS1
}

export PROMPT_COMMAND=prompt_command
export HOST_COLOUR
export LC_ALL=en_GB.UTF-8  
export LANG=en_GB.UTF-8
export TERM=xterm-256color-italic
# export TERM=xterm-256color
# export PATH="$PATH:/opt/cuda-9.1.85/bin"
# export CUDA_PATH=/opt/cuda-9.1.85
# export PATH="$PATH:/opt/cuda-9.0.176.1/bin"
# export CUDA_PATH=/opt/cuda-9.0.176.1
export PATH="$PATH:/opt/cuda-10.1.168_418_67/bin"
export CUDA_PATH=/opt/cuda-10.1.168_418_67
export CUDA_HOME=/opt/cuda-10.1.168_418_67
export LD_LIBRARY_PATH=$CUDA_PATH/lib64:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=/afs/inf.ed.ac.uk/group/project/biomedTM/users/agrivas/local_cuda:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=/opt/cuDNN-7.1_9.1/lib64:$LD_LIBRARY_PATH
# export CFLAGS=-I/opt/cuDNN-7.1_9.1/include
# export LDFLAGS=-L/opt/cuDNN-7.1_9.1/lib64

CUDNN_VERSION=cuDNN-7.6.0.64_10.1
export LD_LIBRARY_PATH=/opt/$CUDNN_VERSION/lib64:$LD_LIBRARY_PATH
export CUDNN_LIBRARY=/opt/$CUDNN_VERSION/lib64
export CUDNN_INCLUDE_DIR=/opt/$CUDNN_VERSION/include
export CFLAGS=-I$CUDNN_INCLUDE_DIR
export LDFLAGS=-L$CUDNN_LIBRARY

# . /afs/inf.ed.ac.uk/user/a/agrivas/Experimental/order-embeddings-wordnet/distro/install/bin/torch-activate

# If we are on crypt - load local python and bins
if [[ $HOSTNAME == "crypt.inf.ed.ac.uk" ]]
then
	PATH=/disk/data1/radiology/users/agrivas/.local/bin:$PATH
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/disk/data1/radiology/users/agrivas/.local/lib
fi

# Attempt to start gpg-agent if we are on dice
if [[ $HOSTNAME == "bruntsfield.inf.ed.ac.uk" ]]
then
	# gpg-agent will return 0 status in $? if already running
	gpg-agent > /dev/null 2>&1
	# If gpg-agent is not running
	if [ "$?" -ne "0" ]
	then
		# If there is a previous env file, try to parse it.
		# It can be the case that it is running but GPG_AGENT_INFO is not set
		if [ -f "${HOME}/.gpg-agent-info" ]
		then
			# Attempt to set GPG_AGENT_INFO
			. "${HOME}/.gpg-agent-info"
			export GPG_AGENT_INFO
			gpg-agent > /dev/null 2>&1
			# gpg-agent definitely not running, try to start a new instance
			if [ "$?" -ne "0" ]
			then
				# Because of AFS we can't use the standard approach with sockets.
				# http://computing.help.inf.ed.ac.uk/FAQ/how-start-gpg-agent
				gpg-agent --daemon --no-use-standard-socket --write-env-file "${HOME}/.gpg-agent-info" > /dev/null 2>&1
				. "${HOME}/.gpg-agent-info"
				export GPG_AGENT_INFO
			fi
		fi
		GPG_TTY=$(tty)
		export GPG_TTY
	fi
fi
