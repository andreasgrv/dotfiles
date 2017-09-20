# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color'
    #alias dir='dir --color'
    #alias vdir='vdir --color'

    alias grep='grep --color'
    alias fgrep='fgrep --color'
    alias egrep='egrep --color'
fi

#px pygmentize will syntax highlight the code
# like cat - but better.
alias dog='pygmentize'
