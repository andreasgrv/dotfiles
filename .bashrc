# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set PATH so it includes stuff from .local/bin (python stuff etc)
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
fi
export PATH

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=40000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
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
df='\[\e[49m\e[39m\]'

# choose host color based on hash of hostname
# we cherrypick a basic palette of reasonable colours
cherrypkd_colors=(255 111 113 221 210 183 42 248 130)
colour_index=$((`hostname | cksum | cut -d ' ' -f 1` % ${#cherrypkd_colors[@]}))
HOST_COLOUR=${cherrypkd_colors[colour_index]}
# black-fg white-bg
bf="\[\e[38;5;234m\e[48;5;${HOST_COLOUR}m\]"

# black-bg host_colour-fg
bb="\[\e[48;5;234m\e[38;5;${HOST_COLOUR}m\]"

two_par_folders='`pwd | rev | cut -d'/' -f 1,2 | rev`'

function prompt_command {
	# Set PS1 with path truncated to two folders
	path_section="$bf  $two_par_folders$bb$df "
	# Git stuff
	git_untracked=`git status --untracked-files=no --porcelain ${pwd} 2>/dev/null`
	if [[ $? == 0 ]]
	then
		branch=`git branch | grep '^* ' | cut -d ' ' -f 2` 
		if [[ -z "${branch// }" ]]
		then
			branch_sec=" new repo "
		else
			branch_sec=" $branch "
		fi
		num_modified=`echo "$git_untracked" | grep ' M ' | wc -l`
		if [[ $num_modified != 0 ]]
		then
			mod_sec="$num_modified  "
		else
			mod_sec=""
		fi
		num_add=`echo "$git_untracked" | grep '^M ' | wc -l`
		if [[ $num_add != 0 ]]
		then
			add_sec="$num_add  "
		else
			add_sec=""
		fi
		num_stash=`git stash list | wc -l`
		if [[ $num_stash != 0 ]]
		then
			stash_sec="$num_stash  "
		else
			stash_sec=""
		fi
		export PS1="$bf $branch_sec$mod_sec$add_sec$stash_sec$path_section"
	else
		export PS1="$path_section"
	fi
}

export PROMPT_COMMAND=prompt_command
export HOST_COLOUR
export LC_ALL=en_GB.UTF-8  
export LANG=en_GB.UTF-8
export TERM="xterm-256color"
